import 'package:flutter/material.dart';
import 'dart:async'; //for async functions
import 'package:http/http.dart' as http; //to handle http request
import 'dart:convert'; //to convert http response in JSON format

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

//Stateful because we are dealing with real data and update real time
class MyApp extends StatefulWidget {
  @override
  //createState is the method we override
  MyAppState createState() => MyAppState();
}

//Pass the state in here
class MyAppState extends State<MyApp> {
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
    http.Response response = await http.get("https://192.168.0.18:3001/users");
    // if (response.statusCode == 200) {
    //   var jsonResponse = jsonDecode(response.body);
    //   data = jsonResponse['results'];
    //   print(response.body);
    // } else {
    //   print('Request failed with status: ${response.statusCode}.');
    // }

    print(response.body); //will not work unless there's a response.
    setState(() {
      //rebuild the widget and modify the app state
      var convert = jsonDecode(response.body); //convert the data to json
      data = convert['results']; //to get the converted json data in mockoon
    });
    return 'Successful!';
  }

  @override
  Widget build(BuildContext context) {
    //Scaffold provides drawers, snack bars, bottom sheets
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Users'),
      ),
      body: ListView.builder(
        //if data is null then 0 otherwise count the length of data
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    child: Container(
                      child: Text(data[index]['name']),
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
