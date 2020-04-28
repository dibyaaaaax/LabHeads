import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_proj/Student/student.dart';
import'package:web_proj/main.dart';

class AuthorizedPersonnel extends StatefulWidget {


  Future navigate_back(context) async{
    Navigator.pop(context);
  }

  @override
  _authorizedPersonnelState createState() => _authorizedPersonnelState();
}

class _authorizedPersonnelState extends State<AuthorizedPersonnel> {
  _authorizedPersonnelState();

  Future _search() async {

    var response = await http
        .post("http://labheadsbase.000webhostapp.com/authorizedPersonnel.php");

    var data = await jsonDecode(response.body);
    return data;
  }


  DataRow _getDataRow(result) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(result["ID"])),
        DataCell(Text(result["Name"])),
        DataCell(Text(result["LabID"])),
        DataCell(Text(result["Designation"])),
      ],
    );
  }

  _parseDataIntoDataTable(var itemName) {
    return DataTable(
      columns: [
        DataColumn(label: Text("ID"), numeric: true),
        DataColumn(label: Text("Name")),
        DataColumn(label: Text("LabID"), numeric: true),
        DataColumn(label: Text("Designation")),
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
          title: new Text("Authorized Personnel", style: TextStyle(color: Colors.deepPurple, fontFamily: "RobotoMono"),)
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
