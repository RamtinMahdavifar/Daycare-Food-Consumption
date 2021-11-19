import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/View/qrcode.dart';
import 'package:plate_waste_recorder/View/roster_page.dart';
import '../Model/variables.dart';
import 'id_input_page.dart';
import 'package:plate_waste_recorder/View/login_page.dart';

class ViewDataPage extends StatefulWidget {
  String institutionName;
  String institutionAddress;

  ViewDataPage(this.institutionName,this.institutionAddress, {Key? key}) : super(key: key);


  @override
  _ViewDataPageState createState() => _ViewDataPageState();
}

class _ViewDataPageState extends State<ViewDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('View Data For Institution: ${widget.institutionName}')),
      body: Center(
          child: Column(
              children: <Widget>[
                // add an empty SizedBox between column elements
                // to create space between elements
                SizedBox(height: 80.0),
                ViewDataOption("Scan QR Code", (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      setStatusVar("view");
                      return ID_InputPage(InstitutionInfo(widget.institutionName, widget.institutionAddress));
                    }));
                }),
                SizedBox(height: 80.0),
                ViewDataOption("Select From Roster", (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return Roster();
                      }));
                }),
                SizedBox(height: 80.0),
                ViewDataOption("Export Data", (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return LoginPage();
                      }));
                }),
              ]
          )
      )
    );
  }

  Widget ViewDataOption(String optionName, void Function() tapFunction){
    assert(optionName.isNotEmpty);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
        child: SizedBox(width: screenWidth*0.625, height: screenHeight*0.15,
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
              tileColor: Colors.green,
              title: Center(child: Text(optionName)),
              onTap: (){
                Config.log.i("User selected the option: $optionName");
                tapFunction();
              },
            )
        )
    );
  }
}
