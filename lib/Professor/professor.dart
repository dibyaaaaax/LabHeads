import 'package:flutter/material.dart';
import 'package:web_proj/Reports/damagereport.dart';
import 'package:web_proj/Reports/requestBuy.dart';
import 'package:web_proj/LabManagers/addItem.dart';


class Professor extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StuSearch(),
    );
  }
}

class StuSearch extends StatelessWidget{

  Future navigate_back(context) async{
    Navigator.pop(context);
  }

  dummy_func(){
    print("I do nothing");
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

  _welcomeMsg(name) => Text(
    "Welcome, " + name,
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
                              child: _welcomeMsg("Sir"),

                            ),
                            SizedBox(width: MediaQuery.of(context).size.width*0.5,),
                            Container(
                                child: Row(children: <Widget>[
                                  _button("Issued Items", dummy_func, context),
                                  SizedBox(width: 20.0,),
                                  _button("log Out", navigate_back, context)
                                ],)
                            )
                          ],),
                        ),
                      )
                  ),

                  Form(),
                ],)
            )
        )
    );
  }

}

class Form extends StatefulWidget {
  Form({Key key}) : super(key: key);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {

  var _departments = ["Department", "CSE", "ECE", "HCI"];
  var _labs = ["Lab", "Midas", "Shannon", "Tav"];
  var current_dep = ["Department"];
  var current_lab = ["Lab"];


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

  dummy_func(){
    print("I do nothing");
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
                _button("Find Item", DamageReport)

              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text("Search By:"),
                SizedBox(width: 20.0,),
                _dropdown(this.current_lab, _labs, "Labs"),
                SizedBox(width: 20.0,),
                _dropdown(this.current_dep, _departments, "Departments"),

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
                _button("Check Lab Timings", dummy_func),
                SizedBox(width: 20.0,),
                _button("File Damage Report", navigate_Report),
                SizedBox(width: 20.0,),
                _button("Special Request New Items", navigate_Request),
              ]),
          SizedBox(height: 30.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              _button("Check Damage Report", dummy_func),
              SizedBox(width: 20.0,),
              _button("Managers of the Lab", dummy_func)
            ]),

        ],
      ),
    );
  }
}