import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_proj/helperClasses.dart';

class SearchItemsStu extends StatefulWidget {
  final SearchParams query;
  final User user;

  SearchItemsStu({Key key, @required this.user, @required this.query})
      : super(key: key);

  Future navigate_back(context) async {
    Navigator.pop(context);
  }

  @override
  _SearchItemsStuState createState() => _SearchItemsStuState(user, query);
}

class _SearchItemsStuState extends State<SearchItemsStu> {
  final SearchParams query;
  final User user;

  bool _autoValidate = false;
  _SearchItemsStuState(this.user, this.query);
  ItemObject selectedObj;
  bool isSelected = false;
  final _quantKey = GlobalKey<FormState>();
  TextEditingController quantitycontroller = new TextEditingController();
  List<int> selectedItems = new List<int>();
  List<ItemObject> allItems = new List<ItemObject>();

  Future _searchResult() async {
    print("seareching");
    print(query.labname);
    print(query.itemname);
    if (query.labname == "Lab"){
      query.labname = "";
    }
    var response = await http
        .post("http://labheadsbase.000webhostapp.com/searchItemsStu.php", body: {
      "searchQuery": query.itemname,
      "lab": query.labname,
    });

    var data = await jsonDecode(response.body);
    print(data);

    List<ItemObject> map_json = new List<ItemObject>();
    for (var i = 0; i < data.length; i++) {
      ItemObject ll = new ItemObject(data[i]["ItemID"], data[i]["LabID"],
          data[i]["quantity"], data[i]["name"], data[i]["Name"]);
      map_json.add(ll);
    }
    allItems = map_json;
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _onSelectedRow(bool selected, ItemObject item) async {
    setState(() {
      if (selected) {
        selectedObj = item;
        selectedItems.add(_parseIndItem(item));
      } else {
        selectedItems.remove(_parseIndItem(item));
      }
    });
  }

  _bookChecks(ItemObject row) {
    print("inBookCheks");
    if (int.parse(row.quant) < int.parse(quantitycontroller.text)) {
      return false;
    } else {
      return true;
    }
  }

  _parseIndItem(ItemObject item) {
    String a = item.itemId.toString() + item.labId.toString();
    return int.parse(a);
  }

  SingleChildScrollView _parseDataIntoDataTable() {

    return SingleChildScrollView(
        child: DataTable(
      columns: [
        DataColumn(label: Text("Lab Name")),
        DataColumn(label: Text("Item Name")),
        DataColumn(label: Text("Quantity"), numeric: true),
        DataColumn(label: Text("Item ID")),
        DataColumn(label: Text("Lab ID")),
      ],
      rows: allItems
          .map((item) => DataRow(
                selected: selectedItems.contains(_parseIndItem(item)),
                onSelectChanged: (b) {
                  _onSelectedRow(b, item);
                },
                cells: <DataCell>[
                  DataCell(Text(item.labName)),
                  DataCell(Text(item.itemName)),
                  DataCell(Text(item.quant)),
                  DataCell(Text(item.itemId)),
                  DataCell(Text(item.labId)),
                ],
              ))
          .toList(),
    ));
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
        if (_bookChecks(selectedObj)) {
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
                if (snapshot.hasError) {
                  return Text(
                    'Error:\n\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.all(10),
                          //child: SingleChildScrollView(
                          child: _parseDataIntoDataTable(),
                          //),
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
                    ),
                  );
                }
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
  var itemName;
  var labName;

  ItemObject(itemId, labId, quant, itemName, labName) {
    this.itemId = itemId;
    this.labId = labId;
    this.quant = quant;
    this.itemName = itemName;
    this.labName = labName;
  }
}
