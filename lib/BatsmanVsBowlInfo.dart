import 'package:cricket_statistics/batsmanVsBowlerSearch.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BatsVsBowlInfo extends StatefulWidget {
  final batVsBowl;
  final batsman;
  final bowler;
  final leag;
  BatsVsBowlInfo(this.batVsBowl, this.batsman, this.bowler, this.leag,
      {Key key})
      : super(key: key);
  @override
  _BatsVsBowlInfoState createState() => _BatsVsBowlInfoState();
}

class _BatsVsBowlInfoState extends State<BatsVsBowlInfo> {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  var data_by_year = {};
  var all_balls = [];
  var matches = [];
  var wickets = {};
  Map<String, dynamic> all_data = {
    "balls": 0,
    'runs': 0,
    'strike_rate': 0,
    'wides': 0,
    "noballs": 0,
    'fours': 0,
    'sixes': 0,
    'matches': 0,
  };
  SharedPreferences _sharedPreferences;
  DatabaseReference db = FirebaseDatabase.instance.reference();

  Future get_and_format_data() async {
    var all_info = widget.batVsBowl;
    print(all_info.length);
    _sharedPreferences = await SharedPreferences.getInstance();

    print(all_info.length);
    for (var ball in all_info) {
      var balls_deets = _sharedPreferences.getString(ball);
      var ball_deets_map;
      if (balls_deets == null) {
        var ball_data =
            await db.child(widget.leag).child('all_balls').child(ball).once();
        ball_deets_map = ball_data.value;
        var deets_string = json.encode(ball_data.value);
        _sharedPreferences.setString(ball, deets_string);
      } else {
        ball_deets_map = json.decode(balls_deets);
      }
      if (!all_data.containsKey('batting_hand')) {
        all_data['batting_hand'] = ball_deets_map['batting_hand'];
        all_data['bowling_hand'] = ball_deets_map['bowling_hand'];
        all_data['bowling_type'] = ball_deets_map['bowling_type'];
        print(all_data);
      }
      var year = ball_deets_map['year'];
      if (!data_by_year.containsKey(year)) {
        data_by_year[year] = {
          "batting_team": ball_deets_map['batting_team'],
          "bowling_team": ball_deets_map['bowling_team'],
          "runs": 0,
          "balls": 0,
          "strike_rate": 0,
          "fours": 0,
          "sixes": 0,
          "wides": 0,
          "noballs": 0,
          'matches': 0,
          'wickets': 0
        };
      }
      if (ball_deets_map.containsKey("extras")) {
        if (ball_deets_map['extras'].containsKey("noballs")) {
          all_data['noballs'] += 1;
          data_by_year[year]['noballs'] += 1;
        }
        if (ball_deets_map['extras'].containsKey("wides")) {
          all_data['wides'] += 1;
          data_by_year[year]['wides'] += 1;
          continue;
        }
      }
      if (ball_deets_map['runs']['batsman'] == 4) {
        all_data['fours'] += 1;
        data_by_year[year]['fours'] += 1;
      }
      if (ball_deets_map['runs']['batsman'] == 6) {
        all_data['sixes'] += 1;
        data_by_year[year]['sixes'] += 1;
      }
      if (ball_deets_map.containsKey('wicket')) {
        if (["bowled", "caught", "caught and bowled", "lbw", "stumped"]
            .contains(ball_deets_map['wicket']['kind'])) {
          if (!wickets.containsKey(ball_deets_map['wicket']['kind'])) {
            wickets[ball_deets_map['wicket']['kind']] = 1;
          } else {
            wickets[ball_deets_map['wicket']['kind']] += 1;
          }
          data_by_year[year]['wickets'] += 1;
        }
      }
      if (!matches.contains(ball_deets_map['match_id'])) {
        matches.add(ball_deets_map['match_id']);
        data_by_year[year]['matches'] += 1;
        all_data['matches'] += 1;
      }
      data_by_year[year]['runs'] += ball_deets_map['runs']['batsman'];
      all_data['runs'] += ball_deets_map['runs']['batsman'];
      all_data['balls'] += 1;
      data_by_year[year]['balls'] += 1;
    }
    print(all_info.length);
    print(all_data);
    print(data_by_year);
    print(wickets.length);
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.batVsBowl);
    return Scaffold(
      appBar: AppBar(
        title: Text("Batsman vs Bowler"),
      ),
      body: FutureBuilder(
        future: get_and_format_data(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return CircularProgressIndicator();
            case ConnectionState.done:
              return ListView(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Column(children: [
                                Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Image.asset(
                                      'assets/batting.png',
                                      scale: 8,
                                    )),
                                Text(
                                  widget.batsman,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                    margin: EdgeInsets.all(5),
                                    child: RichText(
                                        text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: [
                                          TextSpan(
                                              text: "Batting Hand: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: capitalize(
                                                  all_data['batting_hand']),
                                              style: TextStyle(
                                                  color: Colors.black))
                                        ])))
                              ])),
                          Container(
                              padding: EdgeInsets.only(top: 70),
                              child: Image.asset(
                                'assets/vs.png',
                                scale: 10,
                              )),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Column(children: [
                                Container(
                                    margin: EdgeInsets.only(top: 2, bottom: 2),
                                    child: Image.asset(
                                      'assets/bowling.png',
                                      scale: 6.5,
                                    )),
                                Text(
                                  widget.bowler,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                RichText(
                                    text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                      TextSpan(
                                          text: "Bowling Hand: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: capitalize(
                                              all_data['bowling_hand']),
                                          style: TextStyle(color: Colors.black))
                                    ])),
                                RichText(
                                    text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                      TextSpan(
                                          text: "Bowling Type: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: capitalize(
                                              all_data['bowling_type']),
                                          style: TextStyle(color: Colors.black))
                                    ]))
                              ]))
                        ],
                      ))
                ],
              );
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.none:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
