//HW5.js
//Farley

//Over how many years was the unemployment data collected?
db.unemployment.distinct("Year").length;

//How many states were reported on in this dataset?

//What does this query compute?
//db.unemployment.find({Rate : {$lt: 1.0}}).count()

//Find all counties with unemployment rate higher than 10%

//Calculate the average unemployment rate across all states.

//Find all counties with an unemployment rate between 5% and 8%.

//Find the state with the highest unemployment rate. Hint. Use { $limit: 1 }

//Count how many counties have an unemployment rate above 5%.

//Calculate the average unemployment rate per state by year.

//(Extra Credit) For each state, calculate the total unemployment rate across all counties (sum of all county rates).

//(Extra Credit) The same as Query 10 but for states with data from 2015 onward
