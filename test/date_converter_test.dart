import 'package:test/test.dart';
import 'package:plate_waste_recorder/Helper/date_converter.dart';

void main(){
  group("date conversions",(){
    test("convert from date to string",(){
      expect(convertDateToString(DateTime(2021)),"2021-01-01");
      expect(convertDateToString(DateTime(2155)),"2155-01-01");
      expect(convertDateToString(DateTime(1999)),"1999-01-01");
      expect(convertDateToString(DateTime(2021,10)),"2021-10-01");
      expect(convertDateToString(DateTime(2021,10,21)),"2021-10-21");
      expect(convertDateToString(DateTime(2021,1,1)),"2021-01-01");
      expect(convertDateToString(DateTime(2021,12,31)),"2021-12-31");
      expect(convertDateToString(DateTime(2020,5,22)),"2020-05-22");
    });
    
    test("convert from string to date",(){
      expect(convertStringToDate("2021-01-01"),DateTime(2021,1,1));
      expect(convertStringToDate("2021-1-1"),DateTime(2021,1,1));
      expect(convertStringToDate("2021-12-31"),DateTime(2021,12,31));
      expect(convertStringToDate("2021-5-27"),DateTime(2021,5,27));
      expect(convertStringToDate("2021-05-27"),DateTime(2021,5,27));
      expect(convertStringToDate("2020-02-29"),DateTime(2020,2,29));
    });
  });
  
  
}