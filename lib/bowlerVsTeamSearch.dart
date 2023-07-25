import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'bowlerVsTeamInfo.dart';
import 'loading.dart';
import 'error.dart';
import 'dart:convert';
import 'services.dart';

class BowlerVsTeam extends StatefulWidget {
  final leag;
  BowlerVsTeam(this.leag, {Key key}) : super(key: key);

  @override
  _BowlerVsTeamState createState() => _BowlerVsTeamState();
}

class _BowlerVsTeamState extends State<BowlerVsTeam> {
  var teams;
  var bowler = '';
  var player_list;
  // var pop_names;
  Map<String, String> pop_names = {};

  var team = '';
  Future get_teams_and_pop_names() async {
    teams = await getTeamNames();
    final response = await getPopNamesFromAPI();
    var temp = [];
    if (response.statusCode == 200) {
      var res_body = response.body;
      var parsed = jsonDecode(res_body);

      parsed.forEach((player) {
        var player_dict = Map<String, String>.from(player);

        pop_names[player_dict['popular_name']] = player_dict['name'];
        temp.add(player_dict['popular_name']);
      });
      player_list = List<String>.from(temp);
    } else {
      throw Exception('Failed to load');
    }
    return teams;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bowler Vs Team Search"),
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
                          onPressed: () async {
                            if (bowler == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Please select a bowler")));
                            } else if (team == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Please select a Team")));
                            } else {
                              var data = await getPlayerVsTeamData(
                                  bowler, team, "bowling");
                              if (data == null) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "This player has never played against this team")));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BowlerVsTeamInfo(
                                            data, bowler, team)));
                              }
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
          return Center(child: Error());
        },
        future: get_teams_and_pop_names(),
      ),
    );
  }
}
