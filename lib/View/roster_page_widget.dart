import 'package:plate_waste_recorder/Helper/icons.dart';
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

            ),SizedBox(width: 200),
            Text(StudentID, style: TextStyle(fontSize: 40)),
            SizedBox(width: 200),
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
            SizedBox(width: 180),
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

        )


            ]

      )
  );

}

Widget addNewId(BuildContext context, String btnName, Widget Function() page){
  return Flexible(

      child: SizedBox(
          height: 100,
          width: 650,

          child: ElevatedButton(


              onPressed: () {  Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return page();
                  })); },
              child:Row(
                  children:  <Widget>[

                    Text(btnName,
                      style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(4),// insert your font size here
                      ),),

                    Icon(
                      Icons.person_add,
                      color: Colors.orange,
                      size: 50.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    )

                  ]

              )
          )

      )
  );
}

Widget exportToPdf(BuildContext context, String btnName, Widget Function() page){
  return Flexible(

      child: SizedBox(
          height: 100,
          width: 650,

          child: ElevatedButton(


              onPressed: () {  Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return page();
                  })); },
              child:Row(
                  children:  <Widget>[

                    Text(btnName,
                      style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(4),// insert your font size here
                      ),),

                    Icon(
                      Icons.picture_as_pdf,
                      color: Colors.orange,
                      size: 50.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    )

                  ]

              )
          )

      )
  );
}

