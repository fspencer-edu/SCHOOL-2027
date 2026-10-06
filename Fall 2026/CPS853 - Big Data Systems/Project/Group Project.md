https://citibikenyc.com/system-data?utm_source=chatgpt.com

https://data.cityofchicago.org/Transportation/Taxi-Trips-2024-/ajtu-isnz/about_data?utm_source=chatgpt.com

https://transtats.bts.gov/Homepage.asp

https://data.cityofchicago.org/Transportation/Divvy-Bicycle-Stations-Historical/eq45-8inv?utm_source=chatgpt.com

https://data.cityofchicago.org/Transportation/Divvy-Bicycle-Stations-Historical/eq45-8inv?utm_source=chatgpt.com

https://data.cityofchicago.org/Transportation/CTA-Ridership-Bus-Routes-Daily-Totals-by-Route/jyb9-n7fm?utm_source=chatgpt.com

https://www.ncei.noaa.gov/products/land-based-station/integrated-surface-database?utm_source=chatgpt.com

https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9/about_data

https://www.transtats.bts.gov/Homepage.asp

| Dataset                   | Fit for project      | Why                                                    |
| ------------------------- | -------------------- | ------------------------------------------------------ |
| **NYC 311**               | **Best overall**     | Rich schema, easy timestamp, easy batch/stream/quality |
| **Chicago Taxi**          | Excellent            | Very clean numeric + geographic data                   |
| **US Airlines**           | Excellent but harder | Extremely rich, but much wider/messier                 |
| **NOAA Weather**          | Very good            | Great stream story, more preprocessing                 |
| **Citi Bike**             | Good                 | Easy, but fewer fields                                 |
| **Divvy Station History** | Good                 | Excellent streaming, narrower analysis                 |
| **CTA Bus Ridership**     | Weakest              | Only a few columns                                     |

