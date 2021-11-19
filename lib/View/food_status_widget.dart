import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Model/variables.dart';



Widget foodStatusButton(BuildContext context, String btnName, Widget Function() page){

  return Flexible(
      child: Padding(padding: EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            setStatusVar(btnName);
            Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  return page();
                }));
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              textStyle:
              const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          child: Text(btnName,
            style: TextStyle(
               // fontSize:40.0,
             fontSize: ResponsiveFlutter.of(context).fontSize(4), // insert your font size here
          ),),

        ),
      )
    );

}