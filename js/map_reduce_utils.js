function() {
// Adds common utility functions to the root JS object. These are then
// available for use by the map-reduce functions for each measure.
// lib/qme/mongo_helpers.rb executes this function on a database
// connection.

  var root = this;

  // Takes an arbitrary number of arrays and single values and returns a flattened
  // array of all of the elements with any null values removed. For efficiency, if 
  // called with just a single array then it simply returns that array
  root.normalize = function() {
    if (arguments.length==1 && _.isArray(arguments[0]))
      return arguments[0];
    return _.compact(_.flatten(arguments));
  }

  // returns the number of values which fall between the supplied limits
  // value may be a number or an array of numbers
  root.inRange = function(value, min, max) {
    value = normalize(value);
    var count = 0;
    for (i=0;i<value.length;i++) {
      if ((value[i]>=min) && (value[i]<=max))
        count++;
    }
    return count;
  };
  
  // returns the largest member of value that is within the supplied range
  root.maxInRange = function(value, min, max) {
    value = normalize(value);
    var allInRange = _.select(value, function(v) {return v>=min && v<=max;});
    return _.max(allInRange);
  }
  
  // returns the number of values which are less than the supplied limit
  // value may be a number or an array of numbers
  root.lessThan = function(value, max) {
    value = normalize(value);
    var matching = _.select(value, function(v) {return v<=max;});
    return matching.length;
  };
  
  // Returns true if any conditions[i].end is within the specified period,
  // false otherwise
  root.conditionResolved = function(conditions, startDate, endDate) {
    conditions = normalize(conditions);
    var resolvedWithinPeriod = function(condition) {
      return (condition.end>=startDate && condition.end<=endDate);
    };
    return _.any(conditions, resolvedWithinPeriod);
  };
  
  // Returns the minimum of readings[i].value where readings[i].date is in
  // the supplied startDate and endDate. If no reading meet this criteria,
  // returns defaultValue.
  root.minValueInDateRange = function(readings, startDate, endDate, defaultValue) {
    readings = normalize(readings);
    
    var readingInDateRange = function(reading) {
      return (reading.date>=startDate && reading.date<=endDate);
    };
    
    var allInDateRange = _.select(readings, readingInDateRange);
    if (allInDateRange.length==0)
      return defaultValue;
    var min = _.min(allInDateRange, function(reading) {return reading.value;});
    if (min==undefined)
      return defaultValue;
    return min.value;
  };
  
  // Returns the most recent readings[i].value where readings[i].date is in
  // the supplied startDate and endDate. If no reading meet this criteria,
  // returns defaultValue.
  root.latestValueInDateRange = function(readings, startDate, endDate, defaultValue) {
    readings = normalize(readings);
  
    var readingInDateRange = function(reading) {
      return (reading.date>=startDate && reading.date<=endDate);
    };
    
    var allInDateRange = _.select(readings, readingInDateRange);
    if (allInDateRange.length==0)
      return defaultValue;
    var latest = _.max(allInDateRange, function(reading) {return reading.date;});
    if (latest==undefined)
      return defaultValue;
    return latest.value;
  };
  
  // Returns the number of actions that occur within the specified time period of
  // something. The first two arguments are arrays or single-valued time stamps in
  // seconds-since-the-epoch, timePeriod is in seconds.
  root.actionFollowingSomething = function(something, action, timePeriod) {
    something = normalize(something);
    action = normalize(action);
    if (timePeriod===undefined)
      timePeriod=Infinity;
    
    var result = 0;
    for (i=0; i<something.length; i++) {
      var timeStamp = something[i];
      for (j=0; j<action.length;j++) {
        if (action[j]>=timeStamp && (action[j] <= (timeStamp+timePeriod)))
          result++;
      }
    }
    
    return result;
  }
    
  // Returns all members of the values array that fall between min and max inclusive
  root.selectWithinRange = function(values, min, max) {
    values = normalize(values);
    return _.select(values, function(value) { return value<=max && value>=min; });
  }
  
  // calculates the earliest birthdate for a maximum age given a target date.
  // calculation is inclusive of the full year for the target age
  // returns: (earliest birthdate that will reach by not exceed the age by the target date)
  // age: integer in years
  // effective_date: end of the measurement period, in seconds
  root.earliestBirthdayForThisAge = function(age, effective_date) {
    return calculateDateForAge(age, effective_date, true);
  }
  // calculates the latest birthdate for a minimum age given a target date 
  // returns: (latest birthdate that will reach the age by the target date)
  // age: integer in years
  // effective_date: end of the measurement period, in seconds
  root.latestBirthdayForThisAge = function(age, effective_date) {
    return calculateDateForAge(age, effective_date, false);
  }
  // returns birth date for an age value given a specific date
  // age: integer in years
  // effective_date: end of the measurement period, in seconds
  // is_inclusive: boolean for including or excluding age
  root.calculateDateForAge = function(age, effective_date, is_inclusive) {
    var earliest_birthdate = new Date(effective_date*1000);
    var difference = age;
    if (is_inclusive) difference += 1;
    earliest_birthdate.setFullYear(earliest_birthdate.getFullYear()-difference);
    return earliest_birthdate.getTime()/1000;
  }
  
  
  root.map = function(record, population, denominator, numerator, exclusion) {
    var value = {population: false, denominator: false, numerator: false, 
                 exclusions: false, antinumerator: false, patient_id: record._id,
                 medical_record_id: record.medical_record_number,
                 first: record.first, last: record.last, gender: record.gender,
                 birthdate: record.birthdate, test_id: record.test_id,
                 provider_performances: record.provider_performances,
                 race: record.race, ethnicity: record.ethnicity, languages: record.languages};
    if (population()) {
      value.population = true;
      if (denominator()) {
        value.denominator = true;
        if (numerator()) {
          value.numerator = true;
        } else if (exclusion()) {
          value.exclusions = true;
          value.denominator = false;
        } else {
          value.antinumerator = true;
        }
      }
    }
    emit(ObjectId(), value);
  };

}
