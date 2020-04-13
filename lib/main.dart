import 'package:flutter/material.dart';
import 'Student/student.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frontend',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color.fromRGBO(2, 0, 36, 1),Color.fromRGBO(25, 0, 100, 1.0)]
        )
      ),
      
    child: Material(
      type: MaterialType.transparency,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column( 
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/labmanageicon.png",
                width: 300,
                height: 400,
              ),
              Text(
                "LabHeads",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white54
                )
              )
            ],
          ),
          Center(
            child: VerticalDivider(
              color: Color.fromRGBO(237, 237, 237, 0.7),
              thickness: 2,
              indent: 200,
              endIndent: 200,
            )
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             Form()
            ],
          )
        ]
      )
    ),
    );
  }
}

class Form extends StatefulWidget {
  Form({Key key}) : super(key: key);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {

  _button(text) => RaisedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Student()),
        );
      },
      textColor: Colors.black,
      color: Colors.lightBlue,
      
      child: new Text(
        text,
        style: TextStyle(fontFamily: 'RobotoMono'),
      ),
        
  );

  _textBox(text) =>TextField(
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      labelText: text,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none
        )
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 400,
      child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         
         children: [
          _textBox("Enter Username"),
          SizedBox(height: 10),
          _textBox("Enter Password"),
          SizedBox(height: 10),
          _button("Log In"),
         ],
       ),
    );
  }
}