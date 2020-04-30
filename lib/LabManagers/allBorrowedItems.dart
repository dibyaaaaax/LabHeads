import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import'package:web_proj/main.dart';
import 'package:web_proj/helperClasses.dart';

class AllBorrowedItems extends StatefulWidget {

  final User user;
  //AllIssuedItems({Key key, @required labName}) : super(key: key);

  AllBorrowedItems({Key key, @required this.user}) : super(key: key);

  Future navigate_back(context) async{
  Navigator.pop(context);
}

  @override
  _AllBorrowedItemsState createState() => _AllBorrowedItemsState(user);
}

class _AllBorrowedItemsState extends State<AllBorrowedItems> {
  final User user;
  _AllBorrowedItemsState(this.user);

  Future _issuedData() async {
    print(user.id);
    var response = await http
        .post("http://labheadsbase.000webhostapp.com/itemsBorrowed.php",
        body: {
      "ID": user.id,
        });

    var data = await jsonDecode(response.body);
    return data;
  }

  DataRow _getDataRow(result) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(result["Name"])),
        DataCell(Text(result["name"])),
        DataCell(Text(result["Quantity"])),
        DataCell(Text(result["issuedDate"])),
        DataCell(Text(result["renewalDate"])),
      ],
    );
  }

  _parseDataIntoDataTable(var itemName) {
    return DataTable(
      columns: [
        DataColumn(label: Text("Lab Name")),
        DataColumn(label: Text("Item Name")),
        DataColumn(label: Text("Quantity"), numeric: true),
        DataColumn(label: Text("Issue Date")),
        DataColumn(label: Text("Renewal Date")),
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
        title: new Text("Borrowed Items for "+ user.name, style: TextStyle(color: Colors.deepPurple, fontFamily: "RobotoMono"),)
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
