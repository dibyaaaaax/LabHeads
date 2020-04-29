import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import'package:web_proj/main.dart';
import 'package:web_proj/Reports/StatusScreen.dart';

class Book_Labs extends StatefulWidget {

  final User user;

  Book_Labs({Key key, @required this.user}) : super(key: key);

  Future navigate_back(context) async{
  Navigator.pop(context);
}

  @override
  _Book_LabsState createState() => _Book_LabsState(user);
}

class _Book_LabsState extends State<Book_Labs> {
  final User user;
  _Book_LabsState(this.user);

Future _search() async {
    
    var response = await http
        .post("http://labheadsbase.000webhostapp.com/displabsforbooking.php");

    var data = await jsonDecode(response.body);
    return data;
  }


  DataRow _getDataRow(result) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(result["LabID"])),
        DataCell(Text(result["Name"])),
        DataCell(Text(result["Days"])),
        DataCell(Text(result["Start_time"])),
        DataCell(Text(result["End_time"])),
        DataCell(Text(result["Capacity"])),
      ],
    );
  }

  _parseDataIntoDataTable(var itemName) {
    return DataTable(
      columns: [
        DataColumn(label: Text("LabID"), numeric: true),
        DataColumn(label: Text("Name")),
        DataColumn(label: Text("Days")),
        DataColumn(label: Text("Start Time")),
        DataColumn(label: Text("End Time")),
        DataColumn(label: Text("Capacity")),
      ],
      rows: List.generate(
          itemName.length, (index) => _getDataRow(itemName[index])),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: new Text("Lab Availability for "+user.name, style: TextStyle(color: Colors.deepPurple, fontFamily: "RobotoMono"),)
      ),
      body: Center(
        child: FutureBuilder(
          future: _search(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text(
                  'Error in connection'
                );
              case ConnectionState.active:
              case ConnectionState.waiting:
                return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple));
              case ConnectionState.done:
                if (snapshot.hasError)
                  return Text(
                    'Error:\n\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  );
                return SingleChildScrollView(
                  child:Column(children: <Widget>[
                  _parseDataIntoDataTable(snapshot.data),
                  Form(user: user),
                  ])
                ); 
            }
          },
        ),
      ),
    );
  }
}


class Form extends StatefulWidget {
  final User user;
  
  Form({Key key, @required this.user}) : super(key: key);

  @override
  _FormState createState() => _FormState(user);
}

class _FormState extends State<Form> {
final User user;
_FormState(this.user);

TextEditingController labid = new TextEditingController();
TextEditingController date = new TextEditingController();
TextEditingController stime = new TextEditingController();
TextEditingController etime = new TextEditingController();
var msg = "";

Future _executionStatus(result, context){
  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatusScreen(text:result),
                ),
              );
}

Future _submit(context) async {
  print(user.id);
  print(labid.text);
  print(date.text);
  print(etime.text);
  print(stime.text);
    http.Response response = await http.post("http://labheadsbase.000webhostapp.com/booklabreg.php",
    body: {
      "userid": user.id,
      "labID": labid.text,
      "date": date.text,
      "start_time":stime.text,
      "end_time":etime.text,
    });

    var data = response.body;
    _executionStatus(data, context);
  }

  _inputBox(context, text, TextEditingController controllerName) => Container(
        width: MediaQuery.of(context).size.width*0.25,
        child:   TextFormField(
        controller: controllerName,
        decoration: InputDecoration(
          labelText: text,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(18.0),
            borderSide: new BorderSide())),
        style: TextStyle(color: Colors.blueAccent, fontSize: 14.0),
      ),
);

_button(text, context) => RaisedButton(
      onPressed: (){
        _submit(context);
      },
      textColor: Colors.white,
      color: Colors.deepPurple,
      
      child: new Text(
        text,
        style: TextStyle(fontFamily: 'RobotoMono'),
      ),
        
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.5,
      height: MediaQuery.of(context).size.height*0.8,
      padding: EdgeInsets.only(bottom: 5.0,
                        top: 5.0, left: 20.0),
      color: Colors.black12,
      child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         
         children: [
          Container(
            child: Row(
              children:[
                Text("Lab ID: ",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),),
                SizedBox(width: 65),
                _inputBox(context, "Enter Lab ID", labid),
              ]
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              children:[
                Text("Date: ",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),),
                SizedBox(width: 65),
                _inputBox(context, "Enter Date (YYYY-MM-DD)", date),
              ]
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              children:[
                Text("Start Time: ",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),),
                SizedBox(width: 65),
                _inputBox(context, "Enter the Time (24 Hr Format HH:MM:SS)", stime),
              ]
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              children:[
                Text("End Time: ",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),),
                SizedBox(width: 65),
                _inputBox(context, "Enter the Time (24 Hr Format HH:MM:SS)", etime),
              ]
            ),
          ),
          SizedBox(height: 10),
          _button("Submit Request", context)
         ],
       ),
    );
  }
}