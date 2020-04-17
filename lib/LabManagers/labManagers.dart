import 'package:flutter/material.dart';
import 'package:web_proj/LabManagers/addItem.dart';

/*class LabManagers extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Labs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LabPage(),
    );
  }
} REMOVED FOR NAVIGATION*/

class LabManagers extends StatelessWidget {

  _searchBar(text, context) {
    return TextFormField(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: new Text("Shannon",
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
                  child: _searchBar("Search Item", context),
                ),
                new Container(
                  padding: EdgeInsets.only(left:30),
                  child: _button("Search", context, null),
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
                  child: _button("Students List", context, null),
                )),
                new Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 50, right: 50, bottom: 10, top: 50),
                    child: _button("Items Borrowed", context, null),
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
