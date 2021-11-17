import 'package:flutter/material.dart';
import 'id_input_widget.dart';
import 'institution_page_widgets.dart';
import 'package:plate_waste_recorder/Helper/config.dart';

class ID_InputPage extends StatefulWidget {


  ID_InputPage( {Key? key}) : super(key: key);

  @override
  State<ID_InputPage> createState() => _ID_InputPageState();
}

class _ID_InputPageState extends State<ID_InputPage> {
  @override
  Widget build(BuildContext context) {
    Config.log.i("building id input page");
    return Scaffold(
      appBar: AppBar(title: Text("Scan a Student ID"), leading: backButton(context), actions: [modifyButton()]),
      body: _ID_InputOptions(),
    );
  }


  Widget _ID_InputOptions(){
    return SafeArea(

      child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  <Widget>[
              Flexible(
                  child: Text("Scan a Student ID", style: TextStyle(fontSize: 40))
              ),
              Expanded(
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 300.0,
                )
              ),
              Expanded(
                child: Padding(padding: EdgeInsets.all(0),
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //most of the buttons do not navigate anywhere and have null as their navigation parameter
                        manualInput(context,"Input ID", () => InputIDForm(), 1),

                      ],

                    )),

              ),
            ],
          )
      ),);
  }
}


