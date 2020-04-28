import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:collection';
import 'package:web_proj/main.dart' as main;
import 'package:web_proj/helperClasses.dart';

class LabBookings extends StatefulWidget {
  final User user;

  LabBookings({Key key, @required this.user}) : super(key: key);

  Future navigate_back(context) async {
    Navigator.pop(context);
  }

  @override
  _LabBookingsState createState() => _LabBookingsState(user);
}

class _LabBookingsState extends State<LabBookings> {
  final User user;
  _LabBookingsState(this.user);
  List<BookingObject> allBookings = new List<BookingObject>();
  TextEditingController bookedToController = new TextEditingController();
  List<BookingObject> selectedBookings = new List<BookingObject>();
  List<int> checkBoxKey = new List<int>();

  Future _labBookingsResult() async {
    print(user.id);
    var response = await http.post(
        "http://labheadsbase.000webhostapp.com/getLabBookings.php",
        body: {
          "labID": user.id,
        });

    var data = await jsonDecode(response.body);
    print(data);
    List<BookingObject> map_json = new List<BookingObject>();
    for (var i = 0; i < data.length; i++) {
      BookingObject ll = new BookingObject(
        data[i]["userID"],
        data[i]["date"],
        data[i]["start_time"],
        data[i]["end_time"],
      );
      map_json.add(ll);
    }
    allBookings = map_json;
  }

  Future _bookLab() async {
    List<bool> checkStatus = new List<bool>();
    selectedBookings.forEach((element) async {
      print("booking");
      var response = await http
          .post("http://labheadsbase.000webhostapp.com/bookMyLab.php", body: {
        "userid": element.userID,
        "labID": user.id,
        "date": element.date,
        "start_time": element.startTime,
        "end_time": element.endTime,
      });
      String data = response.body;
      if (data == "Success") {
        checkStatus.add(true);
      } else {
        checkStatus.add(false);
      }
    });
    print("exitedLoop");
    print(checkStatus.length);
    if (checkStatus.contains(false)) {
      _showDialog("Some bookings failed");
    } else {
      _showDialog("Booking Success");
    }
  }

  _onSelectedRow(bool selected, BookingObject booking) async {
    setState(() {
      if (selected) {
        selectedBookings.add(booking);
        checkBoxKey.add(_parseBookingForKey(booking));
      } else {
        selectedBookings.remove(booking);
        checkBoxKey.remove(_parseBookingForKey(booking));
      }
    });
  }

  _parseBookingForKey(BookingObject booking) {
    String a = booking.userID.toString();
    return int.parse(a);
  }

  SingleChildScrollView _parseDataIntoDataTable() {
    return SingleChildScrollView(
        child: DataTable(
      columns: [
        DataColumn(label: Text("Request By")),
        DataColumn(label: Text("Date")),
        DataColumn(label: Text("Starting Time")),
        DataColumn(label: Text("Ending Time")),
      ],
      rows: allBookings
          .map((booking) => DataRow(
                selected: checkBoxKey.contains(_parseBookingForKey(booking)),
                onSelectChanged: (value) {
                  _onSelectedRow(value, booking);
                },
                cells: <DataCell>[
                  DataCell(Text(booking.userID)),
                  DataCell(Text(booking.date)),
                  DataCell(Text(booking.startTime)),
                  DataCell(Text(booking.endTime)),
                ],
              ))
          .toList(),
    ));
  }

  _showDialog(var text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Lab Booking"),
          content: new Text(text),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _bookButton(context) {
    return RaisedButton(
      onPressed: () {
        _bookLab();
      },
      color: Colors.deepPurple,
      child: new Text(
        "Book these",
        style: TextStyle(color: Colors.white, fontFamily: "RobotoMono"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black12,
          title: new Text(
            "Book this lab",
            style:
                TextStyle(color: Colors.deepPurple, fontFamily: "RobotoMono"),
          )),
      body: Center(
        child: FutureBuilder(
          future: _labBookingsResult(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Error in connection');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepPurple));
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text(
                    'Error:\n\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(10),
                        child: _parseDataIntoDataTable(),
                      ),
                      new Container(
                        child: _bookButton(context),
                      )
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }
}

class BookingObject {
  var userID;
  var date;
  var startTime;
  var endTime;

  BookingObject(userID, date, startTime, endTime) {
    this.userID = userID;
    this.date = date;
    this.startTime = startTime;
    this.endTime = endTime;
  }
}
