import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import'package:web_proj/main.dart';

class AllIssuedItems extends StatefulWidget {

  final User user;
  //AllIssuedItems({Key key, @required labName}) : super(key: key);

  AllIssuedItems({Key key, @required this.user}) : super(key: key);

  Future navigate_back(context) async{
  Navigator.pop(context);
}

  @override
  _AllIssuedItemsState createState() => _AllIssuedItemsState(user);
}

class _AllIssuedItemsState extends State<AllIssuedItems> {
  final User user;
  _AllIssuedItemsState(this.user);

  Future _issuedData() async {
    var response = await http
        .post("http://labheadsbase.000webhostapp.com/studentsIssuedList.php",
        body: {
      "ID": user.id,
        });

    var data = await jsonDecode(response.body);
    return data;
  }

  String _changeType(text) {
    if (text == 'S') {
      return "Student";
    } else if (text == 'L') {
      return "Lab";
    } else {
      return "Club";
    }
  }

  DataRow _getDataRow(result) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(result["IssuedToID"])),
        DataCell(Text(result["(CASE WHEN IssuedItems.IssuedTo='S' THEN Students.StudentName WHEN IssuedItems.IssuedTo='L' THEN Labs.Name WHEN IssuedItems.IssuedTo='C' THEN Clubs.ClubName END)"])),
        DataCell(Text(result["ItemName"])),
        DataCell(Text(result["issuedDate"])),
        DataCell(Text(result["renewalDate"])),
        DataCell(Text(result["Quantity"])),
        DataCell(Text(_changeType(result["IssuedTo"]))),
      ],
    );
  }

  _parseDataIntoDataTable(var itemName) {
    return DataTable(
      columns: [
        DataColumn(label: Text("ID"), numeric: true),
        DataColumn(label: Text("Name")),
        DataColumn(label: Text("Item Name")),
        DataColumn(label: Text("Issue Data")),
        DataColumn(label: Text("Renewal Data")),
        DataColumn(label: Text("Quantity"), numeric: true),
        DataColumn(label: Text("Type")),
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
        title: new Text("Issued Items for "+ user.name, style: TextStyle(color: Colors.deepPurple, fontFamily: "RobotoMono"),)
      ),
      body: Center(
        child: FutureBuilder(
          future: _issuedData(),
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
