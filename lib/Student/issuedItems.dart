import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:web_proj/LabManagers/addItem.dart';

// class IssuedItems extends StatelessWidget {
  
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'DamageReport',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: _IssuedItems(),
//     );
//   }
// }

class ItemsData{
  var name;
  var issuedDate;
  var renewDate;
  var labName;
  var quantity;

  ItemsData({this.name,
              this.issuedDate,
              this.renewDate,
              this.labName,
              this.quantity});
  factory ItemsData.fromJson(Map<String, dynamic> json){
    return ItemsData(
      name: json['itemName'],
      issuedDate: json["issuedDate"],
      renewDate: json["renewalDate"],
      labName: json["Name"],
      quantity: json["Quantity"]
    );
  }



// static List<ItemsData> getItems() {
//     return <ItemsData>[
//       ItemsData(name:"kit", 
//                 issuedDate:"2018-10-10",
//                 renewDate: "2018-12-12",
//                 labName: "Shannon",
//                 quantity: "23"),
//       ItemsData(name:"arduino", 
//                 issuedDate:"2018-10-10",
//                 renewDate: "2018-12-12",
//                 labName: "Midas",
//                 quantity: "2"),
//     ];

//     // var list = _getSQLData();
//     // print(list);

//   }

}

class Services{
     static Future<List<ItemsData>> _getSQLData() async{
   print("heree");
    http.Response response = await http.post("http://labheadsbase.000webhostapp.com/issuedItems.php",
    body: {
      "ID": '2017002',
    });
    print("1");
    List<ItemsData> list = _parseResponse(response.body);
    print("2");
    print(list.length);
    print(list[0].labName);
    return list;

 }

  static List<ItemsData> _parseResponse(String response){
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<ItemsData>(
      (json) => ItemsData.fromJson(json)).toList();
  }
}


class IssuedItems extends StatelessWidget {
  Future navigate_back(context) async{
  Navigator.pop(context);
}
_button(text, context) => RaisedButton(
      onPressed: (){navigate_back(context);},
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
                            "Items you've borrowed",
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
                          _button("Go Back", context),
                        ],)
                      )
                    ],),
                  ),
                  )
              ),

              Table(),
            ],)
          )
        )
    );
  }
}

class Table extends StatefulWidget {
  Table({Key key}) : super(key: key);

  @override
  _TableState createState() => _TableState();
}

class _TableState extends State<Table> {
  var msg = "";
  List<ItemsData> items; // = ItemsData._getSQLData();
  void initState(){
    print("plssssssssssssssssss");
    _getItems();
    print(msg);
    print(items.length);

  }
  _getItems(){
    Services._getSQLData().then((data){
      setState(() {
        print(data[0].labName);
        items = data;
        msg = "doneee";
        print(items.length);
      });
      print(items.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: DataTable(
              columns: [
                  DataColumn(label: Text('Item')),
                  DataColumn(label: Text('IssuedOn')),
                  DataColumn(label: Text('RenewalDate')),
                  DataColumn(label: Text('LabName')),
                  DataColumn(label: Text('Quantity')),
                ],
                rows: items.map(
                    (item) => DataRow(
                      cells:[
                        DataCell(
                          Text(item.name),
                          onTap: (){
                          },
                        ),
                        DataCell(
                          Text(item.renewDate),
                          onTap: (){
                          },
                        ),
                        DataCell(
                          Text(item.issuedDate),
                          onTap: (){
                          },
                        ),
                        DataCell(
                          Text(item.labName),
                          onTap: (){
                          },
                        ),
                        DataCell(
                          Text(item.quantity),
                          onTap: (){
                          },
                        ),
                      ]
                    ),

                ).toList(),
              ),
    );
   
  }
}