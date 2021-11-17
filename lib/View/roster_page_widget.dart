import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



Widget RosterRecord(BuildContext context, String btnName, Widget Function() page, String StudentID){

  return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent,style: BorderStyle.solid ,width: 5.0)
      ),

      child: Row(

          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            ElevatedButton(

              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return page();
                    }));

              },
              style: ElevatedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  // textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),

                  primary: Colors.red,
                  ),

              child: Icon(
                Icons.highlight_remove,
                color: Colors.black,
                size: 60.0,

              ),

            ),SizedBox(width: 100),
            Text(StudentID, style: TextStyle(fontSize: 40)),
            SizedBox(width: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return page();
                    }));

              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              child: Icon(
                Icons.qr_code,
                color: Colors.black,
                size: 60.0,

              ),

            ),
            SizedBox(width: 100),
            ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  return page();
                }));

          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              textStyle:
              const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          child: Icon(
          Icons.mode_edit,
          color: Colors.black,
          size: 60.0,

  ),

        ),SizedBox(width: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return page();
                    }));

              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              child: Icon(
                Icons.error,
                color: Colors.black,
                size: 60.0,

              ),

            ),

            ]

      )
  );

}