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
  MyAppState createState() => MyAppState();
}

//Pass the state in here
class MyAppState extends State<MyApp> {
  List data;
  @override
  void initState() {
    super.initState();
    this.getData();
  }

  Future<String> getData() async {
    //await - wait until we get the data
    var response = await http
        .get(Uri.encodeFull("https://localhost:3001/users"), //encode the URL
            headers: {"Accept": "application/json"});

    print(response.body);

    setState(() {
      var convert = jsonDecode(response.body);
      data = convert['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    //Scaffold provides drawers, snack bars, bottom sheets
    return Scaffold(
        appBar: AppBar(
          title: Text('List of Users'),
        ),
        body: Center(

            ///appropriate for list views with a large (or infinite)
            ///number of children because the builder is called only for those
            ///children that are actually visible.
            child: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                child: Column(
              children: <Widget>[
                Card(child: Container(child: Text("${data[index]["name"]}")))
              ],
            ));
          },
        )));
  }
}
