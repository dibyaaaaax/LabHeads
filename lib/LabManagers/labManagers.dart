import 'package:flutter/material.dart';
import 'package:web_proj/LabManagers/addItem.dart';
import 'package:web_proj/LabManagers/allBorrowedItems.dart';
import 'package:web_proj/LabManagers/allIssuedItems.dart';
import 'package:web_proj/LabManagers/searchItems.dart';
import 'package:web_proj/main.dart';

class LabManagers extends StatelessWidget {
  // final String name;
  // LabManagers({Key key, @required this.name}) : super(key: key);
  final User user;

  // In the constructor, require a Todo.
  LabManagers({Key key, @required this.user}) : super(key: key);

  TextEditingController querycontroller = new TextEditingController();

  _searchBar(text, context, query) {
    return TextFormField(
      controller: query,
      decoration: InputDecoration(
        labelText: 'Search Item',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  _button(text, context, goTo) {
    return RaisedButton(
      onPressed: () {
        goTo(context);
      },
      color: Colors.deepPurple,
      textColor: Colors.white,
      child: new Text(text, style: TextStyle(fontFamily: 'RobotoMono')),
    );
  }

  _logout(context) {
    Navigator.pop(context);
  }

  _navigateToAddItem(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddItem()));
  }

  _navigateToIssuedItems(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AllIssuedItems(user: user)));
  }

  _navigateToBorrowedItems(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AllBorrowedItems(user: user)));
  }

  _navigateToSearchItems(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchItems(user: user, query: querycontroller.text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: new Text(user.name,
            style:
                TextStyle(color: Colors.deepPurple, fontFamily: 'RobotoMono')),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: _button("Logout", context, _logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  width: 400,
                  height: 50,
                  child: _searchBar("Search Item", context, querycontroller),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 30),
                  child: _button("Search", context, _navigateToSearchItems),
                )
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                    child: Padding(
                  padding: EdgeInsets.only(
                      left: 100, right: 50, bottom: 10, top: 50),
                  child:
                      _button("Issued Items", context, _navigateToIssuedItems),
                )),
                new Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 50, right: 50, bottom: 10, top: 50),
                    child: _button(
                        "Items Borrowed", context, _navigateToBorrowedItems),
                  ),
                ),
                new Container(
                    child: Padding(
                  padding: EdgeInsets.only(
                      left: 50, right: 100, bottom: 10, top: 50),
                  child: _button("Item Suggestions", context, null),
                )),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black12,
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddItem(context);
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.black,
        tooltip: 'Add Item OR Update Quantity',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
