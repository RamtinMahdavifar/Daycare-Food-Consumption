import 'package:logger/logger.dart';

import 'logger_printer.dart';

class Config {
  static Logger log =
      Logger(level: Level.verbose, printer: SimpleLogPrinter(""));
}
