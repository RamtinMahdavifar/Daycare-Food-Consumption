import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/icons.dart';

Widget backButton(BuildContext context){
  return InkWell(
      onTap: (){
        Navigator.pop(context);
      },
      child: Icon(Icons.arrow_back)
  );
}

Widget modifyButton(){
  return InkWell(
      onTap: () {},
      child: Icon(Icons.edit)
  );
}



Widget menuButton(BuildContext context, String btnName, Widget Function() page,int iconIndex){
  return Flexible(
      child: SizedBox(
          height:150,
          width: 250,
          child: ElevatedButton(
            onPressed: () {  Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  return page();
                })); },
            child:Column(
              children:  <Widget>[

                Text(btnName,
                  style: TextStyle(
                    fontSize: 40.0, // insert your font size here
                  ),),

                Icon(
                  categories[iconIndex].icon,
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
