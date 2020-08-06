import 'package:flutter/material.dart';
import 'dart:async'; //for async functions
import 'package:http/http.dart' as http; //to handle http request
import 'dart:convert'; //to convert http response in JSON format

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

//Stateful because we are dealing with real data and update real time
class MyApp extends StatefulWidget {
  @override
  //createState is the method we override
  MyAppState createState() => new MyAppState();
}

//Pass the state in here
class MyAppState extends State<MyApp> {
  final String url = "http://192.168.0.18:3001/users";
  List data;

  @override
  void initState() {
    //initial state of the widget
    super.initState();
    this.getJsonData();
  }

  //Future represent a potential value/error that will be available at some time in the future
  Future<String> getJsonData() async {
    //await - wait until we get the data
    final response = await http.get(Uri.encodeFull(url), //to encode the url
        headers: {"Accept": "application/json"}); //only accept json response
    // if (response.statusCode == 200) {
    //   var jsonResponse = jsonDecode(response.body);
    //   data = jsonResponse['results'];
    //   print(response.body);
    // } else {
    //   print('Request failed with status: ${response.statusCode}.');
    // }
    setState(() {
      //rebuild the widget and modify the app state
      var convert = jsonDecode(response.body); //convert the data to json
      data = convert['results']; //to get the converted json data in mockoon
    });

    return (response.body);
    //print(response.body); //will not work unless there's a response.
  }

  @override
  Widget build(BuildContext context) {
    //Scaffold provides drawers, snack bars, bottom sheets
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('List of Users'),
      ),
      body: new ListView.builder(
        //if data is null then 0 otherwise count the length of data
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
            child: new Center(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Card(
                    child: new Container(
                      child: new Text(data[index]['name']),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
