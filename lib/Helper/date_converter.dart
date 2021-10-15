import 'package:intl/intl.dart';
import 'package:plate_waste_recorder/Helper/config.dart';

// by default use the date format year-month-day
final DateFormat dateFormat = DateFormat("yyyy-MM-dd");

String convertDateToString(DateTime date){
  Config.log.i("converting date " + date.toString() + " to string");
  String resultingDateString = dateFormat.format(date);
  Config.log.i("string: " + resultingDateString + " resulted from conversion");
  return resultingDateString;
}

DateTime convertStringToDate(String dateString){
  Config.log.i("converting string: " + dateString + " to a DateTime object");
  // TODO: add format validation, could use something like try parse or catch any thrown format exceptions.
  // this throws a format exception if dateString isn't in the format yyyy-MM-dd
  return dateFormat.parse(dateString);
}


