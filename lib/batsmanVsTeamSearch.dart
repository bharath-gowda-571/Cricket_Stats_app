import 'dart:developer';

import 'package:cricket_statistics/batsmanVsTeamInfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'loading.dart';
import 'error.dart';

class BatsmanVsTeam extends StatefulWidget {
  final leag;
  BatsmanVsTeam(this.leag, {Key key}) : super(key: key);

  @override
  _BatsmanVsTeamState createState() => _BatsmanVsTeamState();
}

class _BatsmanVsTeamState extends State<BatsmanVsTeam> {
  final db = FirebaseDatabase.instance.reference();
  var teams;
  var batsman = '';
  var player_list;
  var pop_names;
  var team = '';
  Future get_teams_and_pop_names() async {
    await db
        .child(widget.leag)
        .child('teams')
        .once()
        .then((DataSnapshot snapshot) {
      var teams_temp = snapshot.value;
      teams = List<String>.from(teams_temp);
    });
    await db
        .child(widget.leag)
        .child('player_pop_names')
        .once()
        .then((DataSnapshot snapshot) {
      pop_names = snapshot.value;
      player_list = List<String>.from(pop_names.keys);
    });
    return teams;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Batsman Vs Team Search"),
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
                        "Team",
                        style: Theme.of(context).textTheme.headline6,
                      )),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: SearchField(
                        hint: "Search Team",
                        maxSuggestionsInViewPort: 7,
                        searchInputDecoration:
                            InputDecoration(border: OutlineInputBorder()),
                        suggestions: teams,
                        hasOverlay: false,
                        onTap: (value) {
                          team = value;
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
                            } else if (team == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Please select a Team")));
                            } else {
                              db
                                  .child(widget.leag)
                                  .child("player_vs_team")
                                  .child(batsman)
                                  .child('batting')
                                  .child(team)
                                  .once()
                                  .then((snapshot) {
                                // print(snapshot.value);
                                if (snapshot.value == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "This player has never played against this team")));
                                } else {
                                  // print(batsman + "," + team);
                                  // print('something');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BatsmanVsTeamInfo(snapshot.value,
                                                  batsman, team, widget.leag)));
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
