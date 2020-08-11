import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //to handle http request
import 'dart:convert'; //to convert http response in JSON format
import 'package:second_app/user.dart';
import './user.dart';

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
  static const String HOSTNAME = "192.168.0.18";
  static const String PORT = "3001";
  // this is an example of string interpolation
  static const String API_ENDPOINT = "http://$HOSTNAME:$PORT/users";

  bool isLoading = false;
  List<User> users; // dont use the variable "data" because everything is data

  @override
  void initState() {
    //initial state of the widget
    super.initState();
    this.isLoading = true;
    // never leave nulls
    this.users = List();
    this.getJsonData();
  }

  void getJsonData() async {
    http.Response response = await http.get(API_ENDPOINT);

    if (response.statusCode == 200) {
      Iterable jsonIteratable = jsonDecode(response.body);

      // this is using the ability to call functional programming-like calls
      // this line converts the data (json) to actual objects to be used
      // this is called 'deserialization'
      // this is the beauty of dart. it may look like a voodoo spell,
      // but this is one very readable code
      users = List.from(jsonIteratable)
          .map((model) => User.fromJson(model))
          .toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    setState(() {
      //rebuild the widget and modify the app state
      var convert = jsonDecode(response.body); //convert the data to json
      data = convert['results']; //to get the converted json data in mockoon
      // setting the object attr with the local var
      this.users = users;
      this.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Scaffold provides drawers, snack bars, bottom sheets
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Users'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: this.users.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Card(
                          child: Container(
                            child: Text(users[index].name),
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
