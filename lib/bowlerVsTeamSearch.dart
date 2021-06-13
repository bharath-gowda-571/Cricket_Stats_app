import 'dart:developer';

import 'package:cricket_statistics/batsmanVsTeamInfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'bowlerVsTeamInfo.dart';

class BowlerVsTeam extends StatefulWidget {
  final leag;
  BowlerVsTeam(this.leag, {Key key}) : super(key: key);

  @override
  _BowlerVsTeamState createState() => _BowlerVsTeamState();
}

class _BowlerVsTeamState extends State<BowlerVsTeam> {
  final db = FirebaseDatabase.instance.reference();
  var teams;
  var bowler = '';
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
                        "Bowler",
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
                          hint: "Search Bowler",
                          onTap: (value) {
                            bowler = pop_names[value];
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
                            if (bowler == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Please select a bowler")));
                            } else if (team == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Please select a Team")));
                            } else {
                              db
                                  .child(widget.leag)
                                  .child("player_vs_team")
                                  .child(bowler)
                                  .child('bowling')
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BowlerVsTeamInfo(snapshot.value,
                                                  bowler, team, widget.leag)));
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
        future: get_teams_and_pop_names(),
      ),
    );
  }
}
