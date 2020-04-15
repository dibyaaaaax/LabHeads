import 'package:flutter/material.dart';

class AddItem extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Item',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NewItems(),
    );
  }
}

class NewItems extends StatelessWidget {
  _button(text, context, goTo) {
    return RaisedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => goTo()));
      },
      color: Colors.deepPurple,
      textColor: Colors.white,
      child: new Text(text, style: TextStyle(fontFamily: 'RobotoMono')),
    );
  }

  _logout(context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.black12,
          title: Text(
            'Add Item to Inventory',
            style:
                TextStyle(color: Colors.deepPurple, fontFamily: 'RobotoMono'),
          ),
          automaticallyImplyLeading: true),
      body: ItemForm(),
    );
  }
}

class ItemForm extends StatefulWidget {
  ItemForm({Key key}) : super(key: key);

  @override
  ItemFormState createState() {
    return ItemFormState();
  }
}

class ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _itemID;
  String _name;
  int _quantity;
  bool _update;

  _button(text, context, gotTo, update) {
    return new RaisedButton(
      onPressed: () {
        _update = update;
        gotTo();
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

  _inputField(text, validationFunc, saverVar) {
    return new TextFormField(
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
        onSaved: (String arg) {
          saverVar = arg;
        });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              child: new Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(
                      right: 350, left: 350, top: 80, bottom: 10),
                  child: _inputField("Item ID", itemIDValidator, _itemID),
                ),
                new Container(
                  padding: EdgeInsets.only(
                      right: 350, left: 350, top: 10, bottom: 10),
                  child: _inputField("Name", nameValidator, _name),
                ),
                new Container(
                  padding: EdgeInsets.only(
                      right: 350, left: 350, top: 10, bottom: 50),
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
                        child: _button(
                            "Add Item", context, _validateInputs, false)),
                    new Container(
                        padding: EdgeInsets.all(20),
                        child: _button(
                            "Update Quantity", context, _validateInputs, false))
                  ],
                )
              ],
            ),
          )),
        ),
      ),
    );
  }

  itemIDValidator(String arg) {
    if (arg.length < 1) {
      return "Length can't be less than 1";
    } else if (arg.length >= 1) {
      if (_update) {
        // Skip
      } else {
        // Implement idAlreadyInUse() function to check validity
      }
      return "Function not implemented";
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
