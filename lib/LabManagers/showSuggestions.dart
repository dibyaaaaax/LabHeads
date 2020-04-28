import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:collection';
import 'package:web_proj/main.dart' as main;
import 'package:web_proj/helperClasses.dart';

class ShowSuggestions extends StatefulWidget {
  final User user;

  ShowSuggestions({Key key, @required this.user}) : super(key: key);

  Future navigate_back(context) async {
    Navigator.pop(context);
  }

  @override
  _ShowSuggestionsState createState() => _ShowSuggestionsState(user);
}

class _ShowSuggestionsState extends State<ShowSuggestions> {
  final User user;
  _ShowSuggestionsState(this.user);
  List<SuggestionsObj> allSuggestions = new List<SuggestionsObj>();

  Future _suggestionResult() async {
    print(user.id);
    var response = await http.post(
        "http://labheadsbase.000webhostapp.com/showItemSuggestions.php",
        body: {
          "labID": user.id,
        });

    var data = await jsonDecode(response.body);
    print(data);
    List<SuggestionsObj> map_json = new List<SuggestionsObj>();
    for (var i = 0; i < data.length; i++) {
      SuggestionsObj ll = new SuggestionsObj(
        data[i]["ItemName"],
        data[i]["Expected_budget"],
        data[i]["Quantity"],
      );
      map_json.add(ll);
    }
    allSuggestions = map_json;
  }

  SingleChildScrollView _parseDataIntoDataTable() {
    return SingleChildScrollView(
        child: DataTable(
      columns: [
        DataColumn(label: Text("Item Name")),
        DataColumn(label: Text("Expected Budget")),
        DataColumn(label: Text("Quantity Required")),
      ],
      rows: allSuggestions
          .map((suggestion) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(suggestion.itemname)),
                  DataCell(Text(suggestion.expbudget)),
                  DataCell(Text(suggestion.quantity)),
                ],
              ))
          .toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black12,
          title: new Text(
            "Item Suggestions",
            style:
                TextStyle(color: Colors.deepPurple, fontFamily: "RobotoMono"),
          )),
      body: Center(
        child: FutureBuilder(
          future: _suggestionResult(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Error in connection');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepPurple));
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text(
                    'Error:\n\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(10),
                        child: _parseDataIntoDataTable(),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }


}

class SuggestionsObj{
  var quantity;
  var expbudget;
  var itemname;

  SuggestionsObj(itemname, expbudget, quantity){
    this.quantity = quantity;
    this.expbudget = expbudget;
    this.itemname = itemname;
  }
}