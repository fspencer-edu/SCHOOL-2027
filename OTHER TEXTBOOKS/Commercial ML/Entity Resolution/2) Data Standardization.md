- Match or deduplicate data sources to present consistent data
- Data standarization
# Sample Problem

- Connect data by matching the names of the MPs between the two sets of records
	- Resolve entities so that we can create a single combined record for each MP

# Environment Setup

- Set up entity resolution environment
- Python and JupyterLab IDE

# Acquiring Data

## Wikipedia Data

- Imports the requests and Beautiful Soup Python packages and use them to download a copy of the html text

```python
import requests
from bs4 import BeautifulSoup

website_url = requests.get(url).text
soup = BeautifulSoup(website_url,'html.parser')
tables = soup.find_all('table')

import pandas as pd

for table in tables:
   if 'Member returned' in table.text:
      headers = [header.text.strip() for header in table.find_all('th')]
      headers = headers[:5]
      dfrows = []
      table_rows = table.find_all('tr')
      for row in table_rows:
         td = row.find_all('td')
         dfrow = [row.text for row in td if row.text!='\n']
         dfrows.append(dfrow)

df_w = pd.DataFrame(dfrows, columns=headers)

df_w = df_w[['Constituency','Member returned','Notes']]
```


## TheyWorkForYou Data

```python
url = "https://www.theyworkforyou.com/mps/?f=csv"
df_t = pd.read_csv(url, header=0)
```

- Define a function that we can apply along the axis of the DataFrame

### Adding Facebooks Links

```python
def facelink(url):
   website_url = requests.get(url).text
   soup = BeautifulSoup(website_url,'html.parser')
   flinks = [f"{item['href']}" for item in soup.select
      ("a[href*='facebook.com']")]
   if flinks[0]!="https://www.facebook.com/TheyWorkForYou":
      return(flinks[0])
   else:
      return("")
      
df_t['Flink'] = df_t.apply(lambda x: facelink(x.URI), axis=1)

df_t = df_t[['Constituency','First name','Last name','Flink']]

```

# Cleansing Data

- Join the datasets and see further inconsistencies that need to be standardized

## Wikipedia

- Remove blank rows and trailing `\n` characters

```python
df = df.dropna()

df_w['Constituency'] = df_w['Constituency'].str.rstrip("\n")
df_w['Fullname'] = df_w['Fullname'].str.rstrip("\n")

df_w['Fullname'] = df_w['Fullname'].str.lstrip("\n")
```

- Split `Fullname` into `Firstname` and `Lastname`
	- Match values independently
	- Select the first substring and the remaining substrings, separated by spaces

```python
df_w['Firstname'] = df_w['Fullname'].str.split().str[0]
df_w['Lastname'] = df_w['Fullname'].astype(str).apply(lambda x:
   ' '.join(x.split()[1:]))
```

## TheyWorkForYou

- Standardize the column names with those of the previous DataFrame

```python
df_t = df_t.rename(columns={'Last name' : 'Lastname',
                             'First name' : 'Firstname'})
```

# Attribute Comparison

- Simple exact match

```python
len(df_w.merge(df_t, on=['Constituency','Firstname','Lastname']))
599

len(df_w.merge(df_t, on=['Constituency'] ))
623
```

# Constituency

- Standardize upper and lowercase characters

# Measuring Performance

- True postitive matches
- False postitive matches
- True negative matches
- False negative matches
- Precision
- Recall
- Accuracy

# Sample Calculation


- Use the combined information to test hypothesis about the correlation between social media presence and the likelihood or re-election
- Calculate the number of MPs who currently have FB accounts who held their seats in the 2019 election

```python
df_heldwithface = df_resolved[(df_resolved['Flink']!="") &
      (df_resolved['Notes']=="Seat held\n")]
len(df_heldwithface)
474
```