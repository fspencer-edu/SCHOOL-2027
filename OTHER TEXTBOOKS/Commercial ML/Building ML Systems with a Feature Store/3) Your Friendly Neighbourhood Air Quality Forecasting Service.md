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
# Feature Pipeline
# Training Pipeline
# Batch Inference Pipeline
# Running the Pipelines

# Function Calling with LLMs