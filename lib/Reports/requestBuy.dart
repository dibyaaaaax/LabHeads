import 'package:flutter/material.dart';

class RequestBuy extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RequestForm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RequestForm(),
    );
  }
}

class RequestForm extends StatelessWidget {
  _button(text) => RaisedButton(
      onPressed: (){},
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
          child: Container(
            child: Column(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.1,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 5.0,
                        top: 5.0, left: 10.0),
                        child: Text(
                            "Request new items",
                            style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.5,),
                      Container(
                        child: Row(children: <Widget>[
                          _button("Issued Items"),
                          SizedBox(width: 20.0,),
                          _button("log Out")
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
  _inputBox(context, text) => Container(
        width: MediaQuery.of(context).size.width*0.25,
        child:   TextFormField(
        decoration: InputDecoration(
          labelText: text,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(18.0),
            borderSide: new BorderSide())),
        style: TextStyle(color: Colors.blueAccent, fontSize: 14.0),
      ),
);

_button(text) => RaisedButton(
      onPressed: (){},
      textColor: Colors.white,
      color: Colors.deepPurple,
      
      child: new Text(
        text,
        style: TextStyle(fontFamily: 'RobotoMono'),
      ),
        
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.5,
      height: MediaQuery.of(context).size.height*0.8,
      padding: EdgeInsets.only(bottom: 5.0,
                        top: 5.0, left: 20.0),
      color: Colors.black12,
      child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         
         children: [
          Container(
            child: Row(
              children:[
                Text("Item Name",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),
                ),
                SizedBox(width: 30),
                _inputBox(context, "Item Name"),
              ]
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              children:[
                Text("Quantity",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),),
                SizedBox(width: 40),
                _inputBox(context, "Quantity"),
              ]
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              children:[
                Text("Lab ID",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),),
                SizedBox(width: 65),
                _inputBox(context, "Lab ID"),
              ]
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              children:[
                Text("Department ID",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),),
                SizedBox(width: 25),
                _inputBox(context, "Department ID"),
              ]
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              children:[
                Text("Cost",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),),
                SizedBox(width: 65),
                _inputBox(context, "Expected Budget for total quantity"),
              ]
            ),
          ),
          SizedBox(height: 10),
          _button("Submit Report")
         ],
       ),
    );
  }
}