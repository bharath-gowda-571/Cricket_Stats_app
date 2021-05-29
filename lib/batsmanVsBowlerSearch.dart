// import 'dart:html';

import 'package:cricket_statistics/BatsmanVsBowlInfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class BatVsBowlSearch extends StatefulWidget {
  final leag;
  BatVsBowlSearch(this.leag, {Key key}) : super(key: key);
  @override
  _BatVsBowlSearchState createState() => _BatVsBowlSearchState();
}

class _BatVsBowlSearchState extends State<BatVsBowlSearch> {
  final db = FirebaseDatabase.instance.reference();
  var pop_names;
  var batsman = '';
  var bowler = '';
  var player_list;

  Future get_pop_names() async {
    await db
        .child(widget.leag)
        .child('player_pop_names')
        .once()
        .then((DataSnapshot snapshot) {
      pop_names = snapshot.value;
      player_list = List<String>.from(pop_names.keys);
    });
    return pop_names;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Players"),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return ListView(
                children: [
                  Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "Batsman",
                        style: TextStyle(fontSize: 17),
                      )),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: SearchField(
                          suggestions: player_list,
                          hasOverlay: false,
                          searchInputDecoration:
                              InputDecoration(border: OutlineInputBorder()),
                          maxSuggestionsInViewPort: 20,
                          hint: "Search Batsman",
                          onTap: (value) {
                            batsman = pop_names[value];
                          })),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "Bowler",
                        style: TextStyle(fontSize: 17),
                      )),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: SearchField(
                        hint: "Search Bowler",
                        searchInputDecoration:
                            InputDecoration(border: OutlineInputBorder()),
                        suggestions: player_list,
                        hasOverlay: false,
                        onTap: (value) {
                          bowler = pop_names[value];
                        },
                      )),
                  Container(
                      margin: EdgeInsets.all(30),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(15)),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).buttonColor)),
                          onPressed: () {
                            if (batsman == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Please select a batsman")));
                            } else if (bowler == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Please select a bowler")));
                            } else {
                              db
                                  .child(widget.leag)
                                  .child("players_balls_involved")
                                  .child(batsman)
                                  .child("batting")
                                  .child(bowler)
                                  .once()
                                  .then((snapshot) {
                                // print(snapshot.value);
                                if (snapshot.value == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "These players have never face off")));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BatsVsBowlInfo(
                                              snapshot.value,
                                              batsman,
                                              bowler,
                                              widget.leag)));
                                }
                              });
                            }
                          },
                          child: Text(
                            "Get Data",
                            style: Theme.of(context).textTheme.button,
                          )))
                ],
              );
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
          }
        },
        future: get_pop_names(),
      ),
    );
  }
}
