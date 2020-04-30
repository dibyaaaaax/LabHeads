import 'package:flutter/material.dart';
import 'package:web_proj/Reports/damagereport.dart';
import 'package:web_proj/Reports/labTimings.dart';
import 'package:web_proj/Reports/requestBuy.dart';
import 'package:web_proj/Clubs/book_labs.dart';
import 'package:web_proj/LabManagers/allBorrowedItems.dart';
import 'package:http/http.dart' as http;
import 'package:web_proj/main.dart';
import 'package:web_proj/Reports/searchResults.dart';
import 'package:web_proj/helperClasses.dart';


/*class Clubs extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clubs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Clubpage(),
    );
  }
}*/

class Clubs extends StatelessWidget{

  final User user;

 // In the constructor, require a Todo.
  Clubs({Key key, @required this.user}) : super(key: key);

  Future navigate_back(context) async{
  Navigator.pop(context);
}

button_pressed(){
  print("button pressed");
}

  _button(text, navigateTo, context) => RaisedButton(
      onPressed: () {
        navigateTo(context);        
      },
      textColor: Colors.white,
      color: Colors.deepPurple,
      
      child: new Text(
        text,
        style: TextStyle(fontFamily: 'RobotoMono'),
      ),
        
  );

    Future navigate_issuedItems(context) async{
  Navigator.push(context, 
  MaterialPageRoute(builder: (context) => AllBorrowedItems(user: user)));}

    Future navigate_book_labs(context) async{
  Navigator.push(context, 
  MaterialPageRoute(builder: (context) => Book_Labs(user: user)));}
  

  _welcomeMsg(name) => Text(
      "Welcome, " + user.name,
      style: TextStyle(
        color: Colors.deepPurpleAccent,
        fontSize: 30.0,
        fontWeight: FontWeight.w900,
      ),
    );
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(),
          child: Container(
            child: Column(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.1,
                color: Colors.black12,
                child: Padding(
                  padding: EdgeInsets.only(),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 5.0,
                        top: 5.0, left: 10.0),
                        child: _welcomeMsg("Legend"),
                      
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.3,),
                      Container(
                        child: Row(children: <Widget>[
                          _button("Issued Items", navigate_issuedItems, context),
                          SizedBox(width: 20.0,),
                          _button("Request Lab(s)", navigate_book_labs, context),
                          SizedBox(width: 20.0,),
                          _button("Log Out", navigate_back, context),
                          SizedBox(width: 10.0,),                        
                        ],)
                      )
                    ],),
                  ),
                  )
              ),

              _Form(user: user),
            ],)
          )
        )
    );
  }

}

class _Form extends StatefulWidget {
  final User user;
  _Form({Key key, @required this.user}) : super(key: key);

  @override
  _FormState createState() => _FormState(user);
}

class _FormState extends State<_Form> {

   final User user;
  _FormState(this.user);
  

var _labs = ["Lab", "CSE Lab", "Shannon Lab", "Midas Lab", "Precog", "BE Lab",
            "D&I Lab", "BioLab", "RFA Lab", "PhyLab", "DesLab", "Aurora", "TavLab"];
var current_lab = ["Lab"];

TextEditingController itemname = new TextEditingController();


//InputNameText field
_inputNameField(context, text) => Container(
        width: MediaQuery.of(context).size.width*0.5,
        child:   TextFormField(
        decoration: InputDecoration(
          labelText: text,
          fillColor: Color.fromRGBO(220, 220, 220, 1),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(18.0),
            borderSide: new BorderSide())),
        style: TextStyle(color: Colors.blueAccent, fontSize: 14.0),
      ),
);

_dropdown(currentItem, _list, listname) => DropdownButton<String>(
      value: currentItem[0],
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          currentItem[0] = newValue;
        });
      },
      items: _list
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
Future navigate_Report(context) async{
  Navigator.push(context, 
  MaterialPageRoute(builder: (context) => DamageReport()));
}

Future navigate_Request(context) async{
  Navigator.push(context, 
  MaterialPageRoute(builder: (context) => RequestBuy()));
}

Future navigate_labTimings(context) async{
  Navigator.push(context, 
  MaterialPageRoute(builder: (context) => LabTimings()));
}

Future navigate_searchResults(context) async{
  Navigator.push(context, 
  MaterialPageRoute(builder: (context) => SearchItemsStu(user: user, query: SearchParams(itemname.text, current_lab[0]))));
}

_button(_text, navigateTo) => RaisedButton(
      onPressed: () {
        navigateTo(context);        
      },
      textColor: Colors.white,
      color: Colors.deepPurple,
      
      child: new Text(
        _text,
        style: TextStyle(fontFamily: 'RobotoMono'),
      ),
        
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.9,
      color: Colors.white,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                _inputNameField(context, "Look for an item"),
                SizedBox(width: 20.0,),
                _button("Find Item", navigate_searchResults)

            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text("Search By:"),
                SizedBox(width: 20.0,),
                _dropdown(this.current_lab, _labs, "Labs"),

            ]),
            SizedBox(height: 50.0,),
            Divider(
              color: Colors.black
            ),
            Text("OR",
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 30.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 50.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                _button("Check Lab Timings", navigate_labTimings),
                SizedBox(width: 20.0,),
                _button("File Damage Report", navigate_Report),
                SizedBox(width: 20.0,),
                _button("Request New Items", navigate_Request),
            ]),            
            

        ],
      ),
    );
  }
}
