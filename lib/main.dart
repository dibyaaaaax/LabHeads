import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'Student/student.dart';
import 'Student/issuedItems.dart';
import 'LabManagers/labManagers.dart';
import 'Clubs/clubs.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management System',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      
      //Please add your routes over here, using your Dart file name as the string.

      routes: <String,WidgetBuilder>{
        'Student':(BuildContext context)=> new Student(),
        'LabManagers':(BuildContext context)=> new LabManagers(),
        'Clubs':(BuildContext context)=> new Clubs(),
      },
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
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'Lab Management System\n',
              style: TextStyle(color: Color.fromRGBO(110, 217, 160, 1)),
                ),
            ],
            ),
          ),
          Row(
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
            indent: 100,
            endIndent: 100,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             Form()
            ],
          )
        ]
    ),
        ],
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
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  String msg = '';

  Future _login() async {
    http.Response response = await http.post("http://labheadsbase.000webhostapp.com/login.php",body: {
      "username": user.text,
      "password": pass.text,
    });
    var data = jsonDecode(response.body);
    
    if(data.length == 0){
      setState(() {
        
        msg = "Wrong Username / Password";
        
        //print("wrong credentials");
      });
    }else{
      print(data[0]["Type"]);
      Navigator.pushNamed(context, data[0]["Type"]);
    }

  } 

  // @override
  // void initState(){
  //   _login();
  // }

  _button(text) => Container(
    width: 400,
    height: 60,
    child: RaisedButton(
      onPressed: () {
        _login();
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

  _textBox(text,TextEditingController controllerName, bool obscureTextVal) =>Container(
    width: 400,
    child: TextField(
      controller: controllerName,
      cursorColor: Colors.black12,
      obscureText: obscureTextVal,
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
           Text(msg,style: TextStyle(fontSize: 18, color: Color(0xffFF1744)),),
           SizedBox(height: 30),
          _textBox("Enter Username",user,false),
          SizedBox(height: 30),
          _textBox("Enter Password",pass,true),
          SizedBox(height: 30),
          _button("LOGIN"),

         ],
       ),
    );
  }
}
