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
Widget menuButton(BuildContext context, String btnName, Widget Function() page){
  return Flexible(
      child: SizedBox(
          height: 100,
          width: 100,
          child: ElevatedButton(
            child: Text(btnName),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return page();
                  }));
            },

          )
      )
  );
}
