// import 'dart:developer';

// import 'package:cricket_statistics/batsmanVsTeamInfo.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'loading.dart';
import 'error.dart';
import 'batsmanVsBowlingTypeInfo.dart';

class BatsmanVsBowlingType extends StatefulWidget {
  final leag;
  BatsmanVsBowlingType(this.leag, {Key key}) : super(key: key);

  @override
  _BatsmanVsBowlingTypeState createState() => _BatsmanVsBowlingTypeState();
}

class _BatsmanVsBowlingTypeState extends State<BatsmanVsBowlingType> {
  final db = FirebaseDatabase.instance.reference();
  // var teams;
  var bowling_types = ['spin', 'pace'];
  var batsman = '';
  var player_list;
  var pop_names;
  var bowling_type = '';
  Future get_teams_and_pop_names() async {
    // await db
    //     .child(widget.leag)
    //     .child('teams')
    //     .once()
    //     .then((DataSnapshot snapshot) {
    //   var teams_temp = snapshot.value;
    //   teams = List<String>.from(teams_temp);
    // });
    await db
        .child(widget.leag)
        .child('player_pop_names')
        .once()
        .then((DataSnapshot snapshot) {
      pop_names = snapshot.value;
      player_list = List<String>.from(pop_names.keys);
    });
    return player_list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Batsman Vs BowlType Search"),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return Center(child: Loading());
            case ConnectionState.none:
              return Center(child: Error());
            case ConnectionState.done:
              return ListView(
                children: [
                  Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "Batsman",
                        style: Theme.of(context).textTheme.headline6,
                      )),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: SearchField(
                          suggestions: player_list,
                          hasOverlay: false,
                          searchInputDecoration:
                              InputDecoration(border: OutlineInputBorder()),
                          maxSuggestionsInViewPort: 7,
                          hint: "Search Batsman",
                          onTap: (value) {
                            batsman = pop_names[value];
                          })),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "Bowling Type",
                        style: Theme.of(context).textTheme.headline6,
                      )),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: SearchField(
                        hint: "Search Bowling Type",
                        maxSuggestionsInViewPort: 7,
                        searchInputDecoration:
                            InputDecoration(border: OutlineInputBorder()),
                        suggestions: bowling_types,
                        hasOverlay: false,
                        onTap: (value) {
                          bowling_type = value;
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
                          onPressed: () async {
                            if (batsman == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Please select a batsman")));
                            } else if (bowling_type == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Please select a Bowling Type")));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context1) {
                                    return Dialog(
                                      // backgroundColor: Colors.white70,
                                      child: Loading(),
                                    );
                                  });
                              await db
                                  .child(widget.leag)
                                  .child("batsman_vs_bowling_type")
                                  .child(batsman)
                                  .child(bowling_type)
                                  .once()
                                  .then((snapshot) {
                                if (snapshot.value == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "This player has never played against this bowling type")));
                                } else {
                                  // print(batsman + "," + team);
                                  // print('something');
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BatsmanVsBowlingTypeInfo(
                                                  snapshot.value,
                                                  batsman,
                                                  bowling_type,
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
              return Center(child: Loading());
          }
        },
        future: get_teams_and_pop_names(),
      ),
    );
  }
}
