import 'package:flutter/material.dart';

/*class StatusScreen extends StatelessWidget {

  var text;
  StatusScreen({Key key, @required this.text}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DamageReport',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Status(text:text),
    );
  }
}*/

class StatusScreen extends StatelessWidget {
  var text;
  StatusScreen({Key key, @required this.text}) : super(key: key);

  _button(text, context) => RaisedButton(
      onPressed: (){Navigator.pop(context);},
      textColor: Colors.white,
      color: Colors.deepPurple,
      
      child: new Text(
        text,
        style: TextStyle(fontFamily: 'RobotoMono'),
      ),
        
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(),
          child: Center(
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 5.0,
                top: 5.0, left: 10.0),
                child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                    ),
                  )
              ),
              SizedBox(height: 30),
              _button("Go Back", context)
            ],)
          )
        )
    );
  }
}