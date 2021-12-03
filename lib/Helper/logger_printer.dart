import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  ///extends simple logPrinter and overrides the log method

  final String className;
  //Class name of currect file


  SimpleLogPrinter(this.className);
  //constructor


  @override
  List<String> log(LogEvent event) {
    ///override method to updated the log msg para based upon event level values

    var color = PrettyPrinter.levelColors[event.level];
    //Color of log msg based upon the log event level

    var emoji = PrettyPrinter.levelEmojis[event.level];
    //emoji to display with msg based upon the log event level

    var message = event.message;
    //msg of current event

    return [color!('$emoji $className - $message')];
  }
}
