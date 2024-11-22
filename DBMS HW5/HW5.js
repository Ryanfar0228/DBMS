//HW5.js
//Farley

//Over how many years was the unemployment data collected?
db.unemployment.distinct("Year").length;

//How many states were reported on in this dataset?
db.unemployment.distinct("State").length;

//What does this query compute?
//db.unemployment.find({Rate : {$lt: 1.0}}).count()
db.unemployment.find({Rate: {$lt: 1.0}}).count();

//Find all counties with unemployment rate higher than 10%
db.unemployment.aggregate([
  { $match: { Rate: { $gt: 10.0 } } },
  { $group: { _id: { County: "$County", State: "$State" } } },
  { $count: "count" }
]);

//Calculate the average unemployment rate across all states.
db.unemployment.aggregate([
  { $group: { _id: null, averageRate: { $avg: "$Rate" } } }
]);

//Find all counties with an unemployment rate between 5% and 8%.
db.unemployment.aggregate([
  { $match: { Rate: { $gte: 5.0, $lte: 8.0 } } },
  { $group: { _id: { County: "$County", State: "$State" } } },
  { $count: "count" }                                            
]);



//Find the state with the highest unemployment rate. Hint. Use { $limit: 1 }
db.unemployment.aggregate([
  { $group: { _id: "$State", avgRate: { $avg: "$Rate" } } }, 
  { $sort: { avgRate: -1 } },                              
  { $limit: 1 }                                            
]);

//Count how many counties have an unemployment rate above 5%.
db.unemployment.aggregate([
  { $match: { Rate: { $gt: 5.0 } } },                          
  { $group: { _id: { County: "$County", State: "$State" } } },  
  { $count: "count" }                                           
]);


//Calculate the average unemployment rate per state by year.
db.unemployment.aggregate([
  { 
    $group: {
      _id: { State: "$State", Year: "$Year" },   
      averageRate: { $avg: "$Rate" }            
    }
  },
  { 
    $sort: { "_id.Year": 1, "_id.State": 1 }     
  }
]);

//(Extra Credit) For each state, calculate the total unemployment rate across all counties (sum of all county rates).

db.unemployment.aggregate([
  { 
    $group: {
      _id: { State: "$State" },                  
      totalRate: { $sum: "$Rate" }               
    }
  },
  { 
    $sort: { "_id.State": 1 }                   
  }
]);

//(Extra Credit) The same as Query 10 but for states with data from 2015 onward
db.unemployment.aggregate([
  { 
    $match: { Year: { $gte: 2015 } }        
  },
  { 
    $group: {
      _id: { State: "$State" },                 
      totalRate: { $sum: "$Rate" }              
    }
  },
  { 
    $sort: { "_id.State": 1 }                    
  }
