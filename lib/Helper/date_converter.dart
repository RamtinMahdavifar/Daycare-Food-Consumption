import 'package:intl/intl.dart';
import 'package:plate_waste_recorder/Helper/config.dart';

// by default use the date format year-month-day
final DateFormat dateFormat = DateFormat("yyyy-MM-dd");

/// converts the input DateTime object to a string representing the date stored
/// by the DateTime object, the returned string has the format yyyy-MM-dd, where
/// yyyy consists of 4 digits representing the year of the input date, MM has 2 digits
/// representing the month of the input date, dd has 2 digits representing the date
/// of the input date
/// Preconditions: None
/// Postconditions: returns a string whose format is specified above, any additional
/// data or fields of the input DateTime object not mentioned above are not included in the returned string,
/// for example minutes, seconds etc
String convertDateToString(DateTime date) {
  Config.log.i("converting date " + date.toString() + " to string");
  String resultingDateString = dateFormat.format(date);
  Config.log.i("string: " + resultingDateString + " resulted from conversion");
  return resultingDateString;
}

/// converts the input string to a DateTime object
/// Preconditions: dateString.isNotEmpty, dateString must have the date format yyyy-MM-dd, ie
/// the first 4 characters of the string must represent the desired year of the resulting DateTime,
/// the next 2 digits after the hyphen represent the months from 1-12 of the desired DateTime, and the last 2
/// digits after the next hyphen represent the date of the desired DateTime, the input date
/// must correspond to the input month, for example if the month 01 is input 1-31 are possible dates
/// but if 04 is input as a month then 1-30 are possible dates. Finally if month or date inputs
/// are less than 10, they can specified using a single digit, ie 2021-1-1 is valid input
/// A FormatException is thrown if the above conditions are not met
/// Postconditions: a DateTime such that the date, month and year represented by this DateTime
/// correspond to the last 1-2 characters, 1-2 characters after the first hyphen and
/// first 4 characters of the input string.
DateTime convertStringToDate(String dateString) {
  Config.log.i("converting string: " + dateString + " to a DateTime object");
  // TODO: add format validation, could use something like try parse or catch any thrown format exceptions.
  // this throws a format exception if dateString isn't in the format yyyy-MM-dd
  return dateFormat.parse(dateString);
}
