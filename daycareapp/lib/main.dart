import 'package:flutter/material.dart';

void main() {
  runApp(
    SelectInstitute(),
  );
}

class SelectInstitute extends StatelessWidget {
  const SelectInstitute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daycare',
      home: ChooseInstitute()
    );
  }
}

class ChooseInstitute extends StatefulWidget {
  @override
  State<ChooseInstitute> createState() => _ChooseInstituteState();
}

class _ChooseInstituteState extends State<ChooseInstitute> {

  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daycare Food Project')),
      body: _mainMenu(),
    );
  }

  void _handleSubmitted(String text){
    _textController.clear();
  }


  Widget _mainMenu(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          InkWell(
            onTap: (){
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      elevation: 5,
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty){
                                  return 'missing fields';
                                }
                                return null;
                              },
                            ),
                            ElevatedButton(
                                onPressed: (){
                                  if(_formKey.currentState!.validate()){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Submited")),
                                    );
                                  }
                                },
                                child: const Text("Submit"))
                          ]
                        )

                      ),
                    );
                  }
              );
            }, //pop up form entry window
            child: Card(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)
                ),
                color: Colors.green,
                elevation: 2,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Container(
                              height: 55,
                              width: 30,
                              child: const Icon(
                                  Icons.add,
                                  color: Colors.white)
                          )
                      ),
                      Expanded(
                          flex: 3,
                          child: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text("Add Institute", style: TextStyle(fontSize: 25, color: Colors.white))
                          )
                      )
                    ]
                )
            ),
          ),

          Flexible(
            child: Card(
                child: ListTile(
                    leading: const Icon(Icons.search),
                    title: Text("Search Institutions"))),
          ),

          Expanded(
            child: ListView(
                children: const <Widget> [
                  Card(
                      child: ListTile(
                          leading: const Icon(Icons.flight_land_rounded),
                          title: Text("First School")
                      )
                  )

                ]
            ),
          ),

        ],
      ),
    );
  }
}
