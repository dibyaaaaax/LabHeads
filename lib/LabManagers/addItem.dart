import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:web_proj/helperClasses.dart';

class AddItem extends StatefulWidget {
  final User user;

  AddItem({Key key, @required this.user}) : super(key: key);

  Future navigate_back(context) async {
    Navigator.pop(context);
  }

  @override
  AddItemState createState() => AddItemState(user);
}

class AddItemState extends State<AddItem> {
  final User user;
  AddItemState(this.user);
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController _itemname = new TextEditingController();
  TextEditingController _itemid = new TextEditingController();
  TextEditingController _quantity = new TextEditingController();

  Future _addItemResult() async {
    print(_itemid.text);
    print(_quantity.text);
    print(_itemname.text);
    print(user.id);
    var response = await http   
        .post("http://labheadsbase.000webhostapp.com/addNewItem.php", body: {
      "itemID": _itemid.text,
      "labIDFrom": user.id,
      "qt": _quantity.text,
      "name": _itemname.text,
    });

    var data = response.body;
    print(data);
    _showDialog(data);
  }

  Future _updateQuantityResult() async {
    print(_itemid.text);
    print(_quantity.text);
    print(_itemname.text);
    print(user.id);
    var response = await http
        .post("http://labheadsbase.000webhostapp.com/updateItemQuantity.php", body: {
      "itemID": _itemid.text,
      "labIDFrom": user.id,
      "qt": _quantity.text,
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
          title: new Text("Lab Booking"),
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

  _button(text, context, gotTo, orge) {
    return new RaisedButton(
      onPressed: () {
        gotTo();
        orge();
      },
      color: Colors.deepPurple,
      textColor: Colors.white,
      child: new Text(text, style: TextStyle(fontFamily: 'RobotoMono')),
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _inputField(text, validationFunc, cont) {
    return new TextFormField(
      controller: cont,
      decoration: InputDecoration(
        labelText: text,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      keyboardType: TextInputType.text,
      validator: (String arg) {
        return validationFunc(arg);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black12,
          title: new Text(
            "Add Item or Update Quantity",
            style:
                TextStyle(color: Colors.deepPurple, fontFamily: "RobotoMono"),
          )),
      body: SingleChildScrollView(
        child: Container(
            child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              new Container(
                padding:
                    EdgeInsets.only(right: 350, left: 350, top: 80, bottom: 10),
                child: _inputField("Item ID", itemIDValidator, _itemid),
              ),
              new Container(
                padding:
                    EdgeInsets.only(right: 350, left: 350, top: 10, bottom: 10),
                child: _inputField("Name", nameValidator, _itemname),
              ),
              new Container(
                padding:
                    EdgeInsets.only(right: 350, left: 350, top: 10, bottom: 50),
                child: _inputField("Quantity", quantityValidator, _quantity),
              ),
              new SizedBox(
                height: 10.0,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      padding: EdgeInsets.all(20),
                      child: _button("Add Item", context, _validateInputs, _addItemResult)),
                  new Container(
                      padding: EdgeInsets.all(20),
                      child:
                          _button("Update Quantity", context, _validateInputs, _updateQuantityResult))
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  itemIDValidator(String arg) {
    if (arg.length < 1) {
      return "Length can't be less than 1";
    } else {
      return null;
    }
  }

  quantityValidator(String arg) {
    if (int.parse(arg) < 1) {
      return "Quantity can't be 0";
    } else {
      return null;
    }
  }

  nameValidator(String arg) {
    if (arg.length < 1) {
      return "Field can't be empty";
    } else {
      return null;
    }
  }
}
