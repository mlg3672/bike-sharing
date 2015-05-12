# Bike Sharing in DC - Kaggle Competition 

The purpose of this program is to forecast the use of bike sharing using training and test data from kiosk locations in the city of DC. 

## Notes about training data set train.csv
columns - type - (range: min - max) - additional inf
1 datetime
2 season ( 1 - 4) 1 = spring, 2 = sum, 3 = fall, 4 = winter
3 holiday - binary
4 working day - binary
5 weather - integer ( 1 - 4) see below
6 temp - float (0.82 - 41) unit Celsius
7 atemp - float - (0.76 - 45.45) feels like temp
8 humidity - integer (0 - 100)
9 windspeed - float (0 - 367)
10 casual - integer (0 - 367) non-registered users
11 registered - float (0-886) registered users
12 count - integer (0-977) number of total rentals

# Weather data detailed
1: Clear, Few clouds, Partly cloudy, Partly cloudy 
2: Mist + Cloudy, Mist + Broken clouds, Mist + Few clouds, Mist 
3: Light Snow, Light Rain + Thunderstorm + Scattered clouds, Light Rain + Scattered clouds 
4: Heavy Rain + Ice Pallets + Thunderstorm + Mist, Snow + Fog 

# Missing, Possibly Relevant data
- registered users that did not use bike sharing service
- day of the week - added!
- type of holidays (religious/ non-religious) e.g. Easter vs. Fourth of July
- theres only one data point when weather is 4 i.e. heavy rain	

# ideas for predicting new values
A. uniformity
B. linear relationship between all variables and users
C. random
D. mean, median of previous values
E. eliminate outliers

# cleaning data
1. parse datetime into year, month, day, hour -done!
2. split data into day/night - done!
3. check for NAs or invalid values
4. new col for day of the week - done!

# Results - Random Forests Feature Importance
              Feature Importance
season         season   14.09448
holiday       holiday   12.43455
workingday workingday   51.56861
weather       weather   21.25630
temp             temp   20.03885
atemp           atemp   18.06537
humidity     humidity   24.19294
windspeed   windspeed   16.00416
hour             hour   82.27093
month           month   24.73300
year             year   82.91560

## General Observations 
1. total users decrease with humidity btw 15 - 100%, drop off to zero < 15%
2. total users increase temp 0 - 35C, decrease after 35 C
3. windspeed only has little impact on total users
4. 2012 has more users than 2011 for every month - must separate years
5. popular hours of use between 7am - 7pm
6. relationship between humidity and temp by season, weather - but lots of overlap
