import 'package:flutter/material.dart';


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

class Category {
String name;
IconData icon;

Category(this.name, this.icon);
}

List<Category> _categories = [
  Category('Food', Icons.fastfood),
  Category('Input Data', Icons.drive_file_rename_outline),
  Category('Roster', Icons.view_list),
  Category('View Data', Icons.pageview),

];

Widget menuButton(BuildContext context, String btnName, Widget Function() page,int iconIndex){
  return Flexible(
      child: SizedBox(
          height: 250,
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
                  _categories[iconIndex].icon,
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
