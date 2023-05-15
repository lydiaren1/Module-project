# Module-project
project for PSY6422 Course

## The Big Mac index
The Big Mac Index is a price index published since 1986 by The Economist as an informal way of measuring the purchasing power parity (PPP) between two currencies and providing a test of the extent to which market exchange rates result in goods costing the same in different countries. 

## Source data
Big Mac prices are from McDonald’s directly and from reporting around the world; exchange rates are from Thomson Reuters (until January 2022) and Refinitiv Datastream (July 2022 on);The data I am using here has been preliminarily collated by [The Economist](https://github.com/TheEconomist/big-mac-data.git), who collate the specific currency exchange rates of different countries each year into their data.

#### Codebook

| variable      | definition                                            | source                     |
| ------------- | ----------------------------------------------------- | -------------------------- |
| date          | Date of observation                                   |
| currency_code | Three-character [ISO 4217 currency code][iso 4217]    |
| country       | Country name                                          |
| local_price   | Price of a Big Mac in the local currency              | McDonalds; _The Economist_ |
| dollar_ex     | Local currency units per dollar                       | _Reuters_                  |
| dollar_price  | Price of a Big Mac in dollars                         |
| USD           | Big Mac index, relative to the US dollar              |
