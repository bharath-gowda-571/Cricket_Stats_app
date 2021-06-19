import 'package:flutter/rendering.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:share/share.dart';
import 'random_ops.dart';
import 'package:flutter/material.dart';

class BatsmanVsBowlingTypeInfo extends StatefulWidget {
  final batVsBowlType;
  final batsman;
  final bowlType;
  final leag;
  BatsmanVsBowlingTypeInfo(
      this.batVsBowlType, this.batsman, this.bowlType, this.leag,
      {Key key})
      : super(key: key);
  @override
  _BatsmanVsBowlingTypeInfoState createState() =>
      _BatsmanVsBowlingTypeInfoState();
}

class _BatsmanVsBowlingTypeInfoState extends State<BatsmanVsBowlingTypeInfo> {
  final textsyle_left = TextStyle(fontSize: 16);
  final rowSpacer = TableRow(children: [
    SizedBox(
      height: 8,
    ),
    SizedBox(
      height: 8,
    ),
    SizedBox(
      height: 8,
    )
  ]);
  Map<String, dynamic> all_data;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data_by_match = {};
    Map<String, dynamic> data_by_year = {};

    return Scaffold(
      appBar: AppBar(
        title: Text('Batsman vs Team'),
      ),
      body: Builder(builder: (BuildContext context) {
        // print(widget.batVsBowlType);
        Map<String, dynamic> all_data = {
          "balls": 0,
          "runs": 0,
          'fours': 0,
          'sixes': 0,
          'noballs': 0,
          'wides': 0,
          "wickets": {},
          "total_wickets": 0
        };
        // print(widget.batVsBowlType.length);
        for (var ball in widget.batVsBowlType) {
          // print();
          var year = ball['year'];
          var match_id = ball['match_id'];
          // print(match_id);
          if (!data_by_year.containsKey(year)) {
            data_by_year[year] = {
              "runs": 0,
              "balls": 0,
              "batting team": ball['batting_team'],
              "wickets": 0,
              "fours": 0,
              "sixes": 0,
              "wides": 0,
              "noballs": 0,
              'matches': [],
            };
          }
          if (!data_by_match.containsKey(match_id)) {
            data_by_match[match_id] = {
              "runs": 0,
              "balls": 0,
            };
            data_by_year[year]['matches'].add(match_id);
          }

          // Counting Balls
          if (!(ball.containsKey("extras") &&
              ball['extras'].containsKey("wides"))) {
            all_data['balls'] += 1;
            data_by_year[year]['balls']++;
            data_by_match[match_id]['balls']++;
          }
          // Counting Wides
          if (ball.containsKey("extras") &&
              ball['extras'].containsKey("wides")) {
            all_data['wides'] += 1;
            data_by_year[year]['wides']++;
          }
          // Couting NoBalls
          if (ball.containsKey("extras") &&
              ball['extras'].containsKey("noballs")) {
            data_by_year[year]['noballs']++;
            all_data['noballs'] += 1;
          }

          // Counting Runs
          all_data['runs'] += ball['runs']['batsman'];
          data_by_year[year]['runs'] += ball['runs']['batsman'];
          data_by_match[match_id]['runs'] += ball['runs']['batsman'];

          // Counting Fours
          if (ball['runs']['batsman'] == 4) {
            all_data['fours']++;
            data_by_year[year]['fours'] += 1;
          }

          // Counting Sixes
          if (ball['runs']['batsman'] == 6) {
            all_data['sixes']++;
            data_by_year[year]['sixes'] += 1;
          }

          // Counting Wickets
          if (ball.containsKey("wicket")) {
            if (["bowled", "caught", "caught and bowled", "lbw", "stumped"]
                .contains(ball['wicket']['kind'])) {
              all_data['total_wickets']++;
              data_by_year[year]['wickets']++;
              if (!all_data['wickets'].containsKey(ball['wicket']['kind'])) {
                all_data['wickets'][ball['wicket']['kind']] = 1;
              } else {
                all_data["wickets"][ball['wicket']['kind']] += 1;
              }
            }
          }
        }
        print(all_data);
        print(data_by_year);
        return SingleChildScrollView(
          child: Column(children: [Text("Something")]),
        );
      }),
    );
  }
}
