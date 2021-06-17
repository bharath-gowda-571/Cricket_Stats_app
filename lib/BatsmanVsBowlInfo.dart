// import 'dart:html';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:share/share.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'random_ops.dart';
import 'loading.dart';
import 'error.dart';

class StrikeRate {
  final String year;
  final double strike_rate;
  final charts.Color barColor;
  StrikeRate(this.year, this.strike_rate, this.barColor);
}

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
  var data_by_year;
  var matches;
  var wickets;
  var data_by_match;
  Map<String, dynamic> all_data;
  SharedPreferences _sharedPreferences;
  DatabaseReference db = FirebaseDatabase.instance.reference();
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
  getData(var data_by_y) {
    List<StrikeRate> data = [];
    var keys = data_by_y.keys.toList();
    keys.sort();
    for (var i in keys) {
      var mat = data_by_y[i]['matches'];
      var sum = 0.0;
      for (var j in mat) {
        sum += data_by_match[j]['balls'] == 0
            ? 0.0
            : (data_by_match[j]['runs'] * 100) / data_by_match[j]['balls'];
      }

      var sr = mat.length == 0 ? 0.0 : sum / mat.length;

      data_by_year[i]['strike rate'] = sr;
      var col;
      if (data_by_y[i]['balls'] < 6) {
        col = charts.ColorUtil.fromDartColor(Colors.blue);
      } else {
        if (sr < 100) {
          col = charts.ColorUtil.fromDartColor(Colors.red);
        } else if (sr > 100 && sr < 150) {
          col = charts.ColorUtil.fromDartColor(Colors.lightGreen);
        } else {
          col = charts.ColorUtil.fromDartColor(Colors.green);
        }
      }

      data.add(StrikeRate(i, sr, col));
    }
    return [
      charts.Series<StrikeRate, String>(
          id: "Strike Rate",
          colorFn: (StrikeRate sr, __) => sr.barColor,
          domainFn: (StrikeRate sr, _) => sr.year,
          measureFn: (StrikeRate sr, _) => sr.strike_rate,
          labelAccessorFn: (StrikeRate sr, _) =>
              sr.strike_rate.toStringAsFixed(0),
          data: data)
    ];
  }

  Future get_and_format_data() async {
    data_by_year = {};
    matches = [];
    wickets = {};
    data_by_match = {};
    all_data = {
      "balls": 0,
      'runs': 0,
      'strike_rate': 0,
      'wides': 0,
      "noballs": 0,
      'fours': 0,
      'sixes': 0,
      'matches': 0,
      'total_wickets': 0
    };

    var temp = [];
    var all_info = widget.batVsBowl;
    _sharedPreferences = await SharedPreferences.getInstance();

    var count = 0;
    for (var ball in all_info) {
      count++;
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
      }

      var year = ball_deets_map['year'];
      var match_id = ball_deets_map['match_id'];
      if (!data_by_match.containsKey(match_id)) {
        data_by_match[match_id] = {'runs': 0, 'balls': 0};
      }
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
          'matches': [],
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
          temp.add(ball);
          if (!wickets.containsKey(ball_deets_map['wicket']['kind'])) {
            wickets[ball_deets_map['wicket']['kind']] = 1;
          } else {
            wickets[ball_deets_map['wicket']['kind']] += 1;
          }
          data_by_year[year]['wickets'] += 1;
        }
      }
      if (!matches.contains(match_id)) {
        matches.add(ball_deets_map['match_id']);
        data_by_year[year]['matches'].add(match_id);
        all_data['matches'] += 1;
      }
      data_by_year[year]['runs'] += ball_deets_map['runs']['batsman'];
      data_by_match[match_id]['runs'] += ball_deets_map['runs']['batsman'];
      all_data['runs'] += ball_deets_map['runs']['batsman'];
      all_data['balls'] += 1;
      data_by_match[match_id]['balls'] += 1;
      data_by_year[year]['balls'] += 1;
    }
    for (var out in wickets.values) {
      all_data['total_wickets'] += out;
    }
  }

  get_data_by_year_widget() {
    List<Widget> lis = [];
    var keys = data_by_year.keys.toList();
    keys.sort();
    for (var i in keys) {
      lis.add(ExpansionTile(
        title: Text(
          i,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        children: [
          Divider(
            thickness: 1.3,
          ),
          Container(
              margin: EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Teams:',
                style: Theme.of(context).textTheme.subtitle2,
                textAlign: TextAlign.left,
              )),
          Container(
              margin: EdgeInsets.only(left: 30),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(0.4),
                  1: FlexColumnWidth(0.1),
                  2: FlexColumnWidth(1)
                },
                children: [
                  rowSpacer,
                  TableRow(children: [
                    TableCell(
                        child: Text(
                      widget.batsman,
                      style: Theme.of(context).textTheme.subtitle1,
                    )),
                    TableCell(
                        child: Text('-',
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text(data_by_year[i]['batting_team'],
                            style: Theme.of(context).textTheme.subtitle1))
                  ]),
                  rowSpacer,
                  TableRow(children: [
                    TableCell(
                        child: Text(widget.bowler,
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text('-',
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                      child: Text(data_by_year[i]['bowling_team'],
                          style: Theme.of(context).textTheme.subtitle1),
                    )
                  ]),
                  rowSpacer
                ],
              )),
          Container(
              margin: EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Data:',
                style: Theme.of(context).textTheme.subtitle2,
                textAlign: TextAlign.left,
              )),
          Container(
              margin: EdgeInsets.only(left: 30),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(0.2),
                  1: FlexColumnWidth(0.1),
                  2: FlexColumnWidth(0.5)
                },
                children: [
                  rowSpacer,
                  TableRow(children: [
                    TableCell(
                        child: Text("Runs",
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text('-',
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text(data_by_year[i]['runs'].toString(),
                            style: Theme.of(context).textTheme.subtitle1))
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Text("Balls",
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text("-",
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text(data_by_year[i]['balls'].toString(),
                            style: Theme.of(context).textTheme.subtitle1))
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Text("Matches",
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text("-",
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text(
                            data_by_year[i]['matches'].length.toString(),
                            style: Theme.of(context).textTheme.subtitle1))
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Text("Wickets",
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text("-",
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text(data_by_year[i]['wickets'].toString(),
                            style: Theme.of(context).textTheme.subtitle1))
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Text("Fours",
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text("-",
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text(data_by_year[i]['fours'].toString(),
                            style: Theme.of(context).textTheme.subtitle1))
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Text("Sixes",
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text("-",
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text(data_by_year[i]['sixes'].toString(),
                            style: Theme.of(context).textTheme.subtitle1))
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Text("Wides",
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(child: Text("-")),
                    TableCell(
                        child: Text(data_by_year[i]['wides'].toString(),
                            style: Theme.of(context).textTheme.subtitle1))
                  ]),
                  TableRow(children: [
                    TableCell(
                        child: Text("No Balls",
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text("-",
                            style: Theme.of(context).textTheme.subtitle1)),
                    TableCell(
                        child: Text(data_by_year[i]['noballs'].toString(),
                            style: Theme.of(context).textTheme.subtitle1))
                  ]),
                  rowSpacer
                ],
              ))
        ],
      ));
    }
    return lis;
  }

  share_all_data(var data) {
    var output_text =
        widget.batsman + " Vs " + widget.bowler + ' in ' + widget.leag + '\n\t';
    output_text += "Matches - ";
    output_text += data['matches'].toString() + "\n\t";
    output_text += "Total Runs - ";
    output_text += data['runs'].toString() + "\n\t";
    output_text += "Total Balls - ";
    output_text += data['balls'].toString() + "\n\t";
    output_text += "Wickets - ";
    output_text += data['total_wickets'].toString() + "\n\t";
    output_text += "Avg Strike Rate - ";
    output_text += data['strike_rate'].toStringAsFixed(4) + "\n\t";
    output_text += "Fours - ";
    output_text += data['fours'].toString() + "\n\t";
    output_text += "Sixes - ";
    output_text += data['sixes'].toString() + "\n\t";
    output_text += "Wides - ";
    output_text += data['wides'].toString() + "\n\t";
    output_text += "No Balls - ";
    output_text += data['noballs'].toString();
    Share.share(output_text);
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey key1 = GlobalKey();
    GlobalKey key2 = GlobalKey();

    const textsyle_left = TextStyle(fontSize: 17);
    return Scaffold(
      appBar: AppBar(
        title: Text("Batsman vs Bowler"),
      ),
      body: FutureBuilder(
        future: get_and_format_data(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return Center(
                child: Loading(),
              );
            case ConnectionState.done:
              Map<String, double> dataMap = {};
              for (var dis in wickets.keys) {
                dataMap[dis] = wickets[dis].toDouble();
              }
              var strike_rate = 0.0;
              var sum = 0.0;
              for (var i in data_by_match.keys) {
                sum += data_by_match[i]['balls'] == 0
                    ? 0.0
                    : (data_by_match[i]['runs'] * 100) /
                        data_by_match[i]['balls'];
              }
              strike_rate = sum / matches.length;
              all_data['strike_rate'] = strike_rate;
              all_data['matches'] = matches.length;
              return SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                            Container(
                                margin: EdgeInsets.only(top: 20, bottom: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Column(children: [
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: 10, bottom: 10),
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
                                                      style:
                                                          DefaultTextStyle.of(
                                                                  context)
                                                              .style,
                                                      children: [
                                                    TextSpan(
                                                      text: "Batting Hand: ",
                                                    ),
                                                    TextSpan(
                                                        text: capitalize(
                                                            all_data[
                                                                'batting_hand']),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                                  ])))
                                        ])),
                                    Container(
                                        padding: EdgeInsets.only(top: 40),
                                        child: Image.asset(
                                          'assets/vs.png',
                                          scale: 10,
                                          color:
                                              Theme.of(context).disabledColor,
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Column(children: [
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: 2, bottom: 2),
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
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: [
                                                TextSpan(
                                                  text: "Bowling Hand: ",
                                                ),
                                                TextSpan(
                                                    text: capitalize(all_data[
                                                        'bowling_hand']),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ])),
                                          Divider(
                                            color: Colors.transparent,
                                            height: 2,
                                          ),
                                          RichText(
                                              text: TextSpan(
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: [
                                                TextSpan(
                                                  text: "Bowling Type: ",
                                                ),
                                                TextSpan(
                                                    text: capitalize(all_data[
                                                        'bowling_type']),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ]))
                                        ]))
                                  ],
                                )),
                            Divider(
                              height: 0,
                              thickness: 2,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                color: Theme.of(context).primaryColor,
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 20),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "All Stats",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.all(0),
                                          iconSize: 25,
                                          splashRadius: 20,
                                          icon: Icon(Icons.share),
                                          onPressed: () async {
                                            share_all_data(all_data);
                                          })
                                    ])),
                            Divider(
                              height: 0,
                              thickness: 3,
                            ),
                            Divider(
                              color: Colors.transparent,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.15),
                                child: Table(
                                  columnWidths: {
                                    0: FlexColumnWidth(0.65),
                                    1: FlexColumnWidth(0.2),
                                    2: FlexColumnWidth(0.5)
                                  },
                                  children: [
                                    TableRow(children: [
                                      TableCell(
                                          child: Text(
                                        "Matches",
                                        style: textsyle_left,
                                      )),
                                      TableCell(child: Text("-")),
                                      TableCell(
                                          child:
                                              Text(matches.length.toString()))
                                    ]),
                                    rowSpacer,
                                    TableRow(children: [
                                      TableCell(
                                          child: Text(
                                        "Total Runs",
                                        style: textsyle_left,
                                      )),
                                      TableCell(child: Text("-")),
                                      TableCell(
                                          child:
                                              Text(all_data['runs'].toString()))
                                    ]),
                                    rowSpacer,
                                    TableRow(children: [
                                      TableCell(
                                          child: Text(
                                        "Total Balls",
                                        style: textsyle_left,
                                      )),
                                      TableCell(child: Text("-")),
                                      TableCell(
                                          child: Text(
                                              all_data['balls'].toString()))
                                    ]),
                                    rowSpacer,
                                    TableRow(children: [
                                      TableCell(
                                          child: Text(
                                        "Wickets",
                                        style: textsyle_left,
                                      )),
                                      TableCell(child: Text("-")),
                                      TableCell(
                                          child: Text(all_data['total_wickets']
                                              .toString()))
                                    ]),
                                    rowSpacer,
                                    TableRow(children: [
                                      TableCell(
                                          child: Text(
                                        "Avg Strike Rate",
                                        style: textsyle_left,
                                      )),
                                      TableCell(child: Text("-")),
                                      TableCell(
                                          child: Text(
                                              strike_rate.toStringAsFixed(2)))
                                    ]),
                                    rowSpacer,
                                    TableRow(children: [
                                      TableCell(
                                          child: Text(
                                        "Fours",
                                        style: textsyle_left,
                                      )),
                                      TableCell(child: Text("-")),
                                      TableCell(
                                          child: Text(
                                              all_data['fours'].toString()))
                                    ]),
                                    rowSpacer,
                                    TableRow(children: [
                                      TableCell(
                                          child: Text(
                                        "Sixes",
                                        style: textsyle_left,
                                      )),
                                      TableCell(child: Text("-")),
                                      TableCell(
                                          child: Text(
                                              all_data['sixes'].toString()))
                                    ]),
                                    rowSpacer,
                                    TableRow(children: [
                                      TableCell(
                                          child: Text(
                                        "Wides",
                                        style: textsyle_left,
                                      )),
                                      TableCell(child: Text("-")),
                                      TableCell(
                                          child: Text(
                                              all_data['wides'].toString()))
                                    ]),
                                    rowSpacer,
                                    TableRow(children: [
                                      TableCell(
                                          child: Text(
                                        "No Balls",
                                        style: textsyle_left,
                                      )),
                                      TableCell(child: Text("-")),
                                      TableCell(
                                          child: Text(
                                              all_data['noballs'].toString()))
                                    ]),
                                  ],
                                )),
                            Divider(
                              color: Colors.transparent,
                            ),
                            Divider(
                              height: 0,
                              thickness: 2,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                color: Theme.of(context).primaryColor,
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 20),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Dissmissal Types",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.all(0),
                                          iconSize: 25,
                                          splashRadius: 20,
                                          icon: Icon(Icons.share),
                                          onPressed: () async {
                                            share_charts(
                                                key1,
                                                "Dissmissal Types\n" +
                                                    widget.batsman +
                                                    " Vs " +
                                                    widget.bowler +
                                                    " in " +
                                                    widget.leag);
                                          })
                                    ])),
                            Divider(
                              height: 0,
                              thickness: 3,
                            ),
                            Divider(
                              color: Colors.transparent,
                            ),
                            RepaintBoundary(
                                key: key1,
                                child: wickets.length == 0
                                    ? Container(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        child: Text(
                                          widget.bowler +
                                              " hasn't dissmissed " +
                                              widget.batsman,
                                          style: TextStyle(
                                              fontSize: 17, color: Colors.grey),
                                          textAlign: TextAlign.center,
                                        ))
                                    : Container(
                                        padding: EdgeInsets.all(20),
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        child: PieChart(
                                          dataMap: dataMap,
                                          legendOptions: LegendOptions(
                                              legendPosition:
                                                  LegendPosition.left,
                                              legendShape: BoxShape.rectangle),
                                          initialAngleInDegree: 45,
                                          chartValuesOptions:
                                              ChartValuesOptions(
                                            decimalPlaces: 0,
                                            showChartValueBackground: true,
                                            chartValueStyle: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ))),
                            Divider(
                              color: Colors.transparent,
                            ),
                            Divider(
                              height: 0,
                              thickness: 2,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                color: Theme.of(context).primaryColor,
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 20),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Strike Rate Over the Years",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.all(0),
                                          iconSize: 25,
                                          splashRadius: 20,
                                          icon: Icon(Icons.share),
                                          onPressed: () async {
                                            share_charts(
                                                key2,
                                                "Strike Rate Over Years\n" +
                                                    widget.batsman +
                                                    " Vs " +
                                                    widget.bowler +
                                                    " in " +
                                                    widget.leag);
                                          })
                                    ])),
                            Divider(
                              height: 0,
                              thickness: 3,
                            ),
                            Divider(
                              color: Colors.transparent,
                            ),
                            data_by_year.length > 7
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.swipe),
                                      Text(
                                          "  Swipe right or left to view more data")
                                    ],
                                  )
                                : SizedBox.shrink(),
                            Divider(
                              color: Colors.transparent,
                            ),
                            RepaintBoundary(
                                key: key2,
                                child: Container(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(children: [
                                            Container(
                                              height: 10,
                                              width: 10,
                                              color: Colors.blue,
                                            ),
                                            Text("  <6 balls")
                                          ]),
                                          Row(children: [
                                            Container(
                                              height: 10,
                                              width: 10,
                                              color: Colors.red,
                                            ),
                                            Text("  <100")
                                          ]),
                                          Row(children: [
                                            Container(
                                              height: 10,
                                              width: 10,
                                              color: Colors.lightGreen,
                                            ),
                                            Text("  100-150")
                                          ]),
                                          Row(children: [
                                            Container(
                                              height: 10,
                                              width: 10,
                                              color: Colors.green,
                                            ),
                                            Text('  150+')
                                          ])
                                        ],
                                      ),
                                      Container(
                                        height: 300,
                                        padding:
                                            EdgeInsets.only(left: 10, right: 5),
                                        child: charts.BarChart(
                                          getData(data_by_year),
                                          animate: false,

                                          behaviors: [
                                            charts.PanAndZoomBehavior(),
                                          ],
                                          domainAxis: charts.OrdinalAxisSpec(
                                            viewport: charts.OrdinalViewport(
                                                '2015', 7),
                                            renderSpec: charts.SmallTickRendererSpec(
                                                labelStyle:
                                                    charts.TextStyleSpec(
                                                        color: charts.ColorUtil
                                                            .fromDartColor(Theme
                                                                    .of(context)
                                                                .hintColor))),
                                          ),

                                          barRendererDecorator:
                                              charts.BarLabelDecorator(
                                            labelPosition:
                                                charts.BarLabelPosition.inside,
                                          ),
                                          primaryMeasureAxis:
                                              charts.NumericAxisSpec(
                                                  tickProviderSpec: charts
                                                      .BasicNumericTickProviderSpec(
                                                          desiredMinTickCount:
                                                              6),
                                                  renderSpec: charts
                                                      .GridlineRendererSpec(
                                                          lineStyle: charts.LineStyleSpec(
                                                              color: charts
                                                                      .ColorUtil
                                                                  .fromDartColor(
                                                                      Theme.of(context)
                                                                          .hintColor)),
                                                          labelStyle: charts
                                                              .TextStyleSpec(
                                                            fontSize: 15,
                                                            color: charts
                                                                    .ColorUtil
                                                                .fromDartColor(Theme.of(
                                                                        context)
                                                                    .hintColor),
                                                          ))),
                                          // barRendererDecorator: charts.BarLabelDecorator(),
                                        ),
                                      )
                                    ]))),
                            Divider(
                              color: Colors.transparent,
                            ),
                            Divider(
                              height: 0,
                              thickness: 2,
                            ),
                            Container(
                                color: Theme.of(context).primaryColor,
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 20),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Data By Year",
                                  style: Theme.of(context).textTheme.headline6,
                                )),
                            Divider(
                              height: 0,
                              thickness: 3,
                            ),
                            Divider(
                              color: Colors.transparent,
                            ),
                          ] +
                          get_data_by_year_widget()));
            case ConnectionState.waiting:
              return Center(child: Loading());
            case ConnectionState.none:
              return Center(child: Error());
              ;
          }
        },
      ),
    );
  }
}
