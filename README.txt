# Bike Sharing in DC - Kaggle Competition 

The purpose of this program is to forecast the use of bike sharing using training and test data from kiosk locations in the city of DC. 

## Notes about original data set train.csv
columns - type - (range: min - max) - additional inf
1 datetime
2 season ( 1 - 4) 1 = spring, 2 = sum, 3 = fall, 4 = winter
3 holiday - binary
4 working day - binary
5 weather - integer ( 1 - 4)
6 temp - float (0.82 - 41) unit Celsius
7 atemp - float - (0.76 - 45.45) feels like temp
8 humidity - integer (0 - 100)
9 windspeed - float (0 - 367)
10 casual - integer (0 - 367) non-registered users
11 registered - float (0-886) registered users
12 count - integer (0-977) number of total rentals

# Missing, Possibly Relevant data
- registered users that did not use bike sharing service

# ideas for exploration of data
A. relatedness of seasonal variables 
B. linear relationship between all variables and users
C. time of day and holiday, working day

# cleaning data
1. parse datetime into year, month, day, hour -done!
2. reconfigure cols 10, 11 as one col named rental type 

