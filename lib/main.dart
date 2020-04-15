import 'package:flutter/material.dart';
import 'Student/student.dart';
import 'Labs/labManagers.dart';

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
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     begin: Alignment.centerLeft,
      //     end: Alignment.centerRight,
      //     colors: [Color.fromRGBO(2, 0, 36, 1),Color.fromRGBO(255,0,247,1)]
      //   )
      // ),
      color: Color.fromRGBO(42, 54, 63, 1),
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
                width: 250,
                height: 300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(width:340),
                  Image.asset(
                    "images/head.png",
                    width: 150,
                    height: 200
                    )
            ],
          ),
          ]
          ),
          VerticalDivider(
            color: Color.fromRGBO(237, 237, 237, 0.5),
            thickness: 1,
            indent: 200,
            endIndent: 200,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             Form()
            ],
          )
        ]
    ),
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

  _button(text) => Container(
    width: 400,
    height: 60,
    child: RaisedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Student()),
        );
      },
      textColor: Colors.black,
      color: Color.fromRGBO(110, 217, 160, 1),
  
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none
          ),
      child: new Text(
        text,
        style: TextStyle(
          fontFamily: 'RobotoMono',
          fontWeight: FontWeight.bold,
          fontSize: 18
          ),
      ),
        
   )
  );

  _textBox(text) =>Container(
    width: 400,
    child: TextField(
      cursorColor: Colors.black12,
      decoration: InputDecoration(
        // fillColor: Colors.white,
        // filled: true,
        labelText: text,
        labelStyle: TextStyle(
          color: Colors.white30
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color.fromRGBO(110, 217, 160, 1))
          )
      ),
    )
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 400,
      child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         
         children: [
          _textBox("Enter Username"),
          SizedBox(height: 30),
          _textBox("Enter Password"),
          SizedBox(height: 30),
          _button("LOGIN"),
         ],
       ),
    );
  }
}