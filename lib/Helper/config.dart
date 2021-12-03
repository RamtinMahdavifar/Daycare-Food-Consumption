import 'package:logger/logger.dart';
import 'logger_printer.dart';

class Config {
  ///Config class to implement global configs
  ///logger log takes the info level and log msg in printer arg
  static Logger log =
      Logger(level: Level.verbose, printer: SimpleLogPrinter(""));
}


