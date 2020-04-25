import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_proj/Student/student.dart';
import'package:web_proj/main.dart';

class LabTimings extends StatefulWidget {


  Future navigate_back(context) async{
  Navigator.pop(context);
}

  @override
  _LabTimingsState createState() => _LabTimingsState();
}

class _LabTimingsState extends State<LabTimings> {
  _LabTimingsState();

  Future _search() async {
    
    var response = await http
        .post("http://labheadsbase.000webhostapp.com/labTimings.php");

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
        title: new Text("Lab Timings", style: TextStyle(color: Colors.deepPurple, fontFamily: "RobotoMono"),)
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
                  child: _parseDataIntoDataTable(snapshot.data),
                ); 
            }
          },
        ),
      ),
    );
  }
}
