# AI System Overview

- Implementation in Jupyter notebooks in Python
	- Feature groups to store data and backfill them with historical data
	- A daily feature pipeline to retrieve new data and store it in the feature store
	- Training pipeline to train an XGBoost regression model and save it in the model registry
	- A batch inference pipeline to download the model, make predictions on new feature data, and read from the feature store to produce air quality forecast/hindcast graphs

- Libraries in Python for the rest of the system
	- REST APIs to read data from weather data sources
	- Pandas for processing the data
	- Hopsworks to store feature data and models
	- XGBoost for ML model as a gradient-boosted decision tree
	- GitHub Actions to schedule notebook to run daily
	- GitHub Pages as a dashboard web page containing the forecasts/hindcast graphs
- UI
	- Streamlit with voice and text-powered UI
- Backend
	- Whisper transformer model that translates voice to text
	- LLM that translates from text to function calls on the AI system

# Air Quality Data

- Python dependency management framework
	- Conda
	- Poetry
	- Vitrualenv
	- Pipenv
# Exploratory Dataset Analysis

- 6 dimensions of any data source
	- Validity
	- Accuracy
	- Consistency
	- Uniqueness
	- Update frequency
	- Completeness

## Air Quality Data

- Data validity
	- A measure of how accurately the data reflects what it is intended to measure
- Data accuracy
	- Refers to how close the measurements are to the true value
- Consistent
	- Predictable pattern and timely

- Check for missing data
	- `isna()`
	- `df.isna().sum()`
	- `df.dropna(inplace=True)`

## Weather Data

- Open-Meteo
	- Download both historical weather data and weather forecast data for the same location as that of your chosen air quality sensor

```python
 url = "https://archive-api.open-meteo.com/v1/archive"
    params = {
        "latitude": latitude,
        "longitude": longitude,
        "start_date": start_date,
        "end_date": end_date,
        "daily": ["temperature_2m_mean", "precipitation_sum",
            "wind_speed_10m_max", "wind_direction_10m_dominant"]
    }
    responses = openmeteo.weather_api(url, params=params)
```


# Creating and Backfilling Feature Groups

- Store featurized DataFrames in the feature groups in the Hopsworks Feature Store
	- Air quality data
	- Historical weather observations and weather forecast data

```python
air_quality_fg = fs.get_or_create_feature_group(
    name='air_quality',
    description='Air Quality observations daily',
    version=1,
    primary_key=['country', 'city', 'street'], 
    expectation_suite = aq_expectation_suite,
    event_time="date",
)    
air_quality_fg.insert(df_aq)
```

```python
weather_fg = fs.get_or_create_feature_group(
    name='weather',
    description='Historical daily weather observations and weather forecasts',
    version=1,
    primary_key=['city'], 
    event_time="date",
    expectation_suite = weather_expectation_suite
) 
weather_fg.insert(df_weather)
```

- Both feature groups are defined an `expectation_suite` parameter
	- Set of data validation rules that we declaratively attach once to the feature group, but are applied every time we write a DataFrame to the feature group
- Great Expectations
	- Open source library for declaratively specifying data validation rules

```python
import great_expectations as ge
aq_expectation_suite = ge.core.ExpectationSuite(
    expectation_suite_name="aq_expectation_suite"
)

aq_expectation_suite.add_expectation(
    ge.core.ExpectationConfiguration(
        expectation_type="expect_column_min_to_be_between"
        kwargs={
            "column":"pm25",
            "min_value":0.0,
            "max_value":500.0,
            "strict_min":True
        }
    )
)
```

# Feature Pipeline

- Write a daily feature pipeline as a separate program
- Read today's PM 2.5 measurement
- Read today's weather data measurements
- Read the weather forecast data for the next 7 days
- Insert all of this data into the air quality and weather feature groups

```python
url = f"{aqicn_url}/?token={AQI_API_KEY}"
data = trigger_request(url)
aq_today_df = pd.DataFrame()
aq_today_df['pm25'] = [data['data']['iaqi'].get('pm25', {}).get('v', None)]
aq_today_df['city'] = city
..
aq_today_df['date'] = datetime.date.today()
air_quality_fg.insert(df_air_quality)

url = "https://api.open-meteo.com/v1/ecmwf"
params = {
        "latitude": latitude,
        "longitude": longitude,
        "hourly": ["temperature_2m", "precipitation", 
"wind_speed_10m", "wind_direction_10m"]
}
responses = openmeteo.weather_api(url, params=params)
hourly_df = # populate with responses data
daily_df = hourly_df.between_time('11:59', '12:01')
weather_fg.insert(daily_df)
```

- API call will return the data into Pandas DF that are then inserted into their respective feature groups
	- Data validation rules will be executed on insert

# Training Pipeline

- XGBoost
	- Open source gradient-boosted decision tree framework
- Select feature to use in the model
- Feature view
	- Defines the schema for a model, its input features and output targets
- Hopsworks
	- Provides a Pandas-like API for selecting feature fro different feature groups and then joining the selected features together using a `query` object

```python
selected_features = \
air_quality_fg.select(['pm25']).join(weather_fg.select_all(on=['city']))

feature_view = fs.create_feature_view(
    name='air_quality_fv',
    version=version,
    labels=['pm25'],
    query=selected_features
)

X_train, X_test, y_train, y_test = feature_view.train_test_split(test_size=0.2)
```

- Reads data, joins the air quality and weather data, and performs a Scikit-Learn random split of the data into features and labels for both training and test sets
- The chosen features are not time dependent
	- Random split over a time-series split
- Fit model to the features and labels from the training set, using the default hyperparameters

```python
clf = XGBRegressor()
clf.fit(X_train, y_train)
```

- Evaluate the trained model, using the features from the test set to produce predications

```python
y_pred = clf.predict(X_test)
mse = mean_squared_error(y_test, y_pred, squared=False)
r2 = r2_score(y_test, y_pred)
plot_importance(clf, max_num_features=4)
```

- Use mean squared error (MSR) and R-squared error to evaluate the regression problem
	- Mean absolute error (MAE)
- Evaluate the feature importance
- Save the output of this training pipeline to a model registry
- Save the model to a local directory and then register the model to the model registry

```python
model_dir = "air_quality_model"
os.makedirs(model_dir + "/images")
clf.save_model(model_dir + "/model.json")
plt.savefig(model_dir + "/images/feature_importance.png")

mr = project.get_model_registry()
mr.python.create_model(
    name="air_quality_xgboost_model", 
    description="Air Quality (PM2.5) predictor.",
    metrics={ "MSE": mse, "r2": r2 },
    feature_view = feature_view
)
mr.save(model_dir)
```

- Model registry client extracts the schema and lineage for the model using the feature view object
- Any other files in the local directory containing the model wil also be uploaded
	- Images

<img src="/images/Pasted image 20261109121922.png" alt="image" width="500">

# Batch Inference Pipeline

- Batch inference pipeline is a Python program that downloads the trained model from the model registry, fetches the weather forecast feature data, and uses the model and the weather forecast data to predict air quality for the next 7 days
- Make 7 different predictions, one for each day
- Create a graph of the air quality forecast
- Download a model from the model registry and load it using the `XGBRegression` object

```python
model_ref = mr.get_model(
    name="air_quality_xgboost_model",
    version=1,
)

saved_model_dir = model_ref.download()
retrieved_xgboost_model = XGBRegressor()
retrieved_xgboost_model.load_model(saved_model_dir + "/model.json")
```

- Read a batch of inference data using the weather feature group

```python
batch_df = weather_fg.filter(weather_fg.date >= today).read()

features = batch_df[['temperature_2m_mean', 'precipitation_sum', \
    'wind_speed_10m_max', 'wind_direction_10m_dominant']]
batch_df['predicted_pm25'] = model.predict(features)
batch_df['days_before_forecast_day'] = range(1, len(batch_df)+1)

monitoring_fg = fs.get_or_create_feature_group(
    name='monitoring_aq',
    description='Monitor Air Quality predictions’,
    version=1,
    primary_key=['city', 'street']
)  
monitoring_fg.insert(batch_df)

import plotly.express as px
fig = px.line(batch_df , x = "date", y = "pm25_predicted", title = "..")
….
fig.write_image(file="forecast.png", format="png", width=1920, height=1280)
```


<img src="/images/Pasted image 20261109122227.png" alt="image" width="500">


# Running the Pipelines

- Run the feature backfill notebook
	- Create the `air_quality` and `weather` feature groups
- Run the feature pipeline and check the feature groups to see if new rows have been added to them as expected
- Train model by running the model training pipeline
- Test batch inference pipeline

## Scheduling the Pipelines as a GitHub Action

- GitHub Actions
	- Used to schedule tests and deploy artifacts
	- Set the repository secret
	- Define the YANL file containing the GitHub Actions
- Workflow
	- Run the steps on a container that uses the latest version of Ubuntu
	- Check out the code in the Git repository to a local directory in the container
	- Install Python
	- Install all Python dependencies
	- Run the feature pipeline followed by the batch inference pipeline

```yaml
on:
  workflow_dispatch:
  #schedule:
  #  - cron: '11 6 * * *'
jobs:
  test_schedule:
    runs-on: ubuntu-latest
    steps:
      - name: checkout repo content
        uses: actions/checkout@v4
      - name: setup python
        uses: actions/setup-python@v4
        with:
         python-version: '3.10.13'
      - name: install python packages
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
      - name: execute pipelines
        env: 
          HOPSWORKS_API_KEY: ${{ secrets.HOPSWORKS_API_KEY }}
        run: |
          cd notebooks/ch03
jupyter nbconvert --to notebook --execute 2_air_quality_feature_pipeline.ipynb
jupyter nbconvert --to notebook --execute 4_air_quality_batch_inference.ipynb
```

## Building the Dashboard as a GitHub Page

- Push the PNG files created by the batch inference pipeline

# Function Calling with LLMs

- Add voice activated UI
	- Whisper transcribes audio into text
	- The transcribed text is fed into a fine-tuned Llama LLM that will return one function, including the parameter values to that function
	- The chosen function will be exectued
	- LLM will return a human understanding answer

<img src="/images/Pasted image 20261109122957.png" alt="image" width="500">

```python
def get_future_data_for_date \
    (date: str, city_name: str, feature_view, model) -> pd.DataFrame:
    """
    Predicts PM2.5 data for a date and city, given feature view and model.

    Args:
        date (str): The target future date in the format 'YYYY-MM-DD'.
        city_name (str): The name of the city for which the prediction is made.
        feature_view: The feature view used to retrieve batch data.
        model: The machine learning model used for prediction.

    Returns:
        pd.DataFrame: predicted PM2.5 values for each day from target date.

    """

def get_future_data_in_date_range(date_start: str, date_end: str, \
    city_name: str, feature_view, model) -> pd.DataFrame:
    """
    Retrieve data for a specific date range and city from a feature view.

    Args:
        date_start (str): The start date in the format "%Y-%m-%d".
        date_end (str): The end date in the format "%Y-%m-%d".
        city_name (str): The name of the city to retrieve data for.
        feature_view: The feature view object.
        model: The machine learning model used for prediction.

    Returns:
        pd.DataFrame: data for the specified date range and city.
    """

```

- Design the following prompt template for the function calling query to the LLM
- Defined the available functions, then include the JSON representation of those functions
	- Parameters, types, and descriptions
- Fine-tuned LLM should also received hints about which function to choose and to be told not to return a function unless it is confident one of them matches the user query

```python
prompt = f"""<|im_start|>system
You are a helpful assistant with access to the following functions:

get_future_data_for_date
get_future_data_in_date_range
get_historical_air_quality_for_date
get_historical_data_in_date_range

{serialize_function_to_json(get_future_data_for_date)}
{serialize_function_to_json(get_future_data_in_date_range)}
{serialize_function_to_json(get_historical_air_quality_for_date)}
{serialize_function_to_json(get_historical_data_in_date_range)}

You need to choose what function to use and retrieve parameters 
for this function from the user input.
Today is {datetime.date.today().strftime("%A")}, {datetime.date.today()}.
IMPORTANT: If the user query contains 'will', it is very likely that you 
will need to use the get_future_data function.
NOTE: Ignore the Feature View and Model parameters.
NOTE: Dates should be provided in the format YYYY-MM-DD.

To use these functions respond with:
<multiplefunctions>
    <functioncall> {fn} </functioncall>
    <functioncall> {fn} </functioncall>
    ...
</multiplefunctions>

Edge cases you must handle:
- If there are no functions that match the user request, 
you will respond politely that you cannot help.<|im_end|>
<|im_start|>user
{prompt}<|im_end|>
<|im_start|>assistant"""
```


