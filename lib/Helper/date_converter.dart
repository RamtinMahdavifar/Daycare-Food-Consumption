import 'package:intl/intl.dart';

// by default use the date format year-month-day
final DateFormat dateFormat = DateFormat("yyyy-MM-dd");

String convertDateToString(DateTime date){
  return dateFormat.format(date);
}

DateTime convertStringToDate(String dateString){
  // TODO: add format validation, could use something like try parse or catch any thrown format exceptions.
  // this throws a format exception if dateString isn't in the format yyyy-MM-dd
  return dateFormat.parse(dateString);
}


