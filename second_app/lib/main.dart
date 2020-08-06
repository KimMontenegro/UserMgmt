import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:second_app/user.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static const String HOSTNAME = "10.0.2.2";
  static const String PORT = "3001";
  // this is an example of string interpolation
  static const String API_ENDPOINT = "http://$HOSTNAME:$PORT/users";

  bool isLoading = false;
  List<User> users; // dont use the variable "data" because everything is data

  @override
  void initState() {
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
      // setting the object attr with the local var
      this.users = users;
      this.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
