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
  TextEditingController nameContoller = TextEditingController();
  List data;

  createAlertDialog(BuildContext context){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('done'),
        content: TextField(
          controller: nameContoller,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('OK'),
            onPressed: () {

              Navigator.of(context).pop(nameContoller.text.toString());
            },
          )
        ],
      );
    });
  }


  @override
  void initState() {
    //initial state of the widget
    super.initState();
    this.getData();
  }

  //Future represent a potential value/error that will be available at some time in the future
  // ignore: missing_return
  Future<String> getData() async {
    //await - wait until we get the data
    var response = await http.get(
        Uri.encodeFull("192.168.0.18:3001/users"), //to encode the url
        headers: {"Accept": "application/json"}); //only accept json response

    print(response.body); //will not work unless there's a response.

    setState(() {
      //rebuild the widget and modify the app state
      var convert = jsonDecode(response.body); //convert the data to json
      data = convert['results']; //to get the converted json data in mockoon
    });
  }

  @override
  Widget build(BuildContext context) {
    //Scaffold provides drawers, snack bars, bottom sheets
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Users'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        //if data is null then 0 otherwise count the length of data
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Center(
              child: Text(data[index]['name']),
            ),
          );
        },
      ),
    );
  }
}
