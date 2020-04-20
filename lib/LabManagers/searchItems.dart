import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_proj/main.dart' as main;

class SearchItems extends StatefulWidget {
  final String query;
  final main.User user;

  SearchItems({Key key, @required this.user, @required this.query})
      : super(key: key);

  Future navigate_back(context) async {
    Navigator.pop(context);
  }

  @override
  _SearchItemsState createState() => _SearchItemsState(user, query);
}

class _SearchItemsState extends State<SearchItems> {
  final String query;
  final main.User user;
  bool _autoValidate = false;
  _SearchItemsState(this.user, this.query);
  ItemObject selectedObj;
  bool isSelected = false;
  final _quantKey = GlobalKey<FormState>();
  TextEditingController quantitycontroller = new TextEditingController();

  Future _searchResult() async {
    print("seareching");
    print(query);
    var response = await http
        .post("http://labheadsbase.000webhostapp.com/searchItems.php", body: {
      "searchQuery": query,
    });

    var data = await jsonDecode(response.body);
    print(data);
    return data;
  }

  Future _bookItem(ItemObject rowData) async {
    print("booking");
    var response = await http
        .post("http://labheadsbase.000webhostapp.com/bookItem.php", body: {
      "itemID": rowData.itemId,
      "labIDFrom": rowData.labId,
      "issuedtoID": user.id,
      "qt": quantitycontroller.text,
    });

    var data = response.body;
    print(data);
    _showDialog(data);
  }

  _showDialog(var text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Item Booking"),
          content: new Text(text),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _bookChecks(ItemObject row) {
    print("inBookCheks");
    if (row.avail == 0 ||
        int.parse(row.quant) < int.parse(quantitycontroller.text)) {
      return false;
    } else {
      return true;
    }
  }

  _parseDataIntoDataTable(var itemData) {
    return DataTable(
        columns: [
          DataColumn(label: Text("Lab Name")),
          DataColumn(label: Text("Item Name")),
          DataColumn(label: Text("Quantity"), numeric: true),
          DataColumn(label: Text("Availability"), numeric: true),
          DataColumn(label: Text("Item ID")),
          DataColumn(label: Text("Lab ID")),
        ],
        rows: List.generate(
            itemData.length,
            (index) => DataRow(
                  //selected: isSelected,
                  onSelectChanged: (value) {
                    setState(() {
                    isSelected = value;
                    if (value) {
                      selectedObj = new ItemObject(
                          itemData[index]["ItemID"],
                          itemData[index]["LabID"],
                          itemData[index]["quantity"],
                          itemData[index]["Availability"]);
                      print("row " + index.toString() + " pressed");
                      print(selectedObj.itemId);
                    }});
                  },
                  cells: <DataCell>[
                    DataCell(Text(itemData[index]["Name"])),
                    DataCell(Text(itemData[index]["name"])),
                    DataCell(Text(itemData[index]["quantity"])),
                    DataCell(Text(itemData[index]["Availability"])),
                    DataCell(Text(itemData[index]["ItemID"])),
                    DataCell(Text(itemData[index]["LabID"])),
                  ],
                )));
  }

  void _validateInputs() {
    if (_quantKey.currentState.validate()) {
      _quantKey.currentState.save();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _bookButton(context) {
    return RaisedButton(
      onPressed: () {
        _validateInputs();
        //print("inputsValidated");
        if (_bookChecks(selectedObj)) {
          //print("book checks passed");
          _bookItem(selectedObj);
        } else {
          _showDialog("Item not available");
        }
      },
      color: Colors.deepPurple,
      child: new Text(
        "Issue Item",
        style: TextStyle(color: Colors.white, fontFamily: "RobotoMono"),
      ),
    );
  }

  _quantityField(context, quant) {
    return TextFormField(
      controller: quant,
      decoration: InputDecoration(
        labelText: 'Enter Quantity',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        } else if (int.parse(value) < 1) {
          return 'Please enter a valid quantity';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black12,
          title: new Text(
            "Search Items",
            style:
                TextStyle(color: Colors.deepPurple, fontFamily: "RobotoMono"),
          )),
      body: Center(
        child: FutureBuilder(
          future: _searchResult(),
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
                if (snapshot.hasError)
                  return Text(
                    'Error:\n\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  );
                return Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: _parseDataIntoDataTable(snapshot.data),
                      ),
                    ),
                    new Container(
                        child: new Form(
                      key: _quantKey,
                      autovalidate: _autoValidate,
                      child: new Container(
                        padding: EdgeInsets.only(
                            right: 350, left: 350, top: 80, bottom: 10),
                        child: _quantityField(context, quantitycontroller),
                      ),
                    )),
                    new Container(
                      child: _bookButton(context),
                    )
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}

class ItemObject {
  var itemId;
  var labId;
  var quant;
  var avail;

  ItemObject(itemId, labId, quant, avail) {
    this.itemId = itemId;
    this.labId = labId;
    this.quant = quant;
    this.avail = avail;
  }
}
