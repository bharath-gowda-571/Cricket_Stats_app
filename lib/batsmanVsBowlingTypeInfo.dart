import 'package:flutter/rendering.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:share/share.dart';
import 'random_ops.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class StrikeRate {
  final String year;
  final double strike_rate;
  final charts.Color barColor;
  StrikeRate(this.year, this.strike_rate, this.barColor);
}

class AverageRuns {
  final String year;
  final double average_runs;
  final charts.Color barColor;
  AverageRuns(this.year, this.average_runs, this.barColor);
}

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
  List<Widget> get_data_each_style_widgets(var data_by_spec, context) {
    // print(data_by_y);
    List<Widget> lis = [];
    var keys = data_by_spec.keys.toList();
    keys.sort();

    for (var i in keys) {
      lis.add(ExpansionTile(
          title: Text(
            i,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          children: [
            Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.025),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(0.8),
                    1: FlexColumnWidth(0.2),
                    2: FlexColumnWidth(0.5)
                  },
                  children: [
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Total Runs',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_spec[i]['runs'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Total Balls',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_spec[i]['balls'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Wickets',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_spec[i]['wickets'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Batting Average',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        // data_by_spec[i]['runs'].toString(),
                        data_by_spec[i]['wickets'] != 0
                            ? (data_by_spec[i]['runs'] /
                                    data_by_spec[i]['wickets'])
                                .toStringAsFixed(2)
                            : "NA",
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Strike Rate',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_spec[i]['balls'] != 0
                            ? ((data_by_spec[i]['runs'] * 100) /
                                    data_by_spec[i]['balls'])
                                .toStringAsFixed(2)
                            : "0",
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                  ],
                ))
          ]));
    }
    return lis;
  }

  get_strike_rate_by_year(var data_by_y, data_by_match) {
    List<StrikeRate> data = [];
    var keys = data_by_y.keys.toList();
    keys.sort();
    for (var i in keys) {
      var sr = data_by_y[i]['strike_rate'];

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

  get_avg_data_for_chart(var data_by_y) {
    List<AverageRuns> data = [];
    var keys = data_by_y.keys.toList();
    keys.sort();
    for (var i in keys) {
      var avg = data_by_y[i]['batting_avg'];
      var col;
      col = charts.ColorUtil.fromDartColor(Colors.blue);
      data.add(AverageRuns(i, avg, col));
    }
    return [
      charts.Series<AverageRuns, String>(
        id: "Batting Average",
        colorFn: (AverageRuns av, __) => av.barColor,
        domainFn: (AverageRuns av, __) => av.year,
        measureFn: (AverageRuns av, __) => av.average_runs,
        labelAccessorFn: (AverageRuns av, _) =>
            av.average_runs.toStringAsFixed(0),
        data: data,
      )
    ];
  }

  List<Widget> get_data_each_year_widgets(var data_by_y, context) {
    List<Widget> lis = [];
    var keys = data_by_y.keys.toList();
    keys.sort();
    for (var i in keys) {
      // data_by_y[i]['positions'].sort();
      lis.add(ExpansionTile(
          title: Text(
            i,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          children: [
            Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.025),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(0.8),
                    1: FlexColumnWidth(0.2),
                    2: FlexColumnWidth(0.5)
                  },
                  children: [
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Team',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['batting team'],
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Innings',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['matches'].length.toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Total Runs',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['runs'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Total Balls',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['balls'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Wickets',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['wickets'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Avg. Strike Rate',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['strike_rate'].toStringAsFixed(2),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Batting Average',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['batting_avg'].toStringAsFixed(2),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Fours',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['fours'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Sixes',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['sixes'].toStringAsFixed(2),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Wides',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['wides'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'No Balls',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['noballs'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                  ],
                ))
          ]));
    }
    return lis;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data_by_match = {};
    Map<String, dynamic> data_by_year = {};
    Map<String, dynamic> data_by_specific_bowl = {};

    GlobalKey key1 = GlobalKey();
    GlobalKey key2 = GlobalKey();
    GlobalKey key3 = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        title: Text('Batsman vs Bowling Type'),
      ),
      body: Builder(builder: (BuildContext context) {
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
        for (var ball in widget.batVsBowlType) {
          var year = ball['year'];
          var match_id = ball['match_id'];
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

          var bowling_style = ball['specific bowling type'];
          if (!data_by_specific_bowl.containsKey(bowling_style)) {
            data_by_specific_bowl[bowling_style] = {
              "runs": 0,
              "balls": 0,
              "wickets": 0,
              "fours": 0,
              "sixes": 0,
              "wides": 0,
              "noballs": 0,
              'matches': []
            };
          }
          if (!data_by_match.containsKey(match_id)) {
            data_by_match[match_id] = {
              "runs": 0,
              "balls": 0,
            };
            data_by_year[year]['matches'].add(match_id);
            data_by_specific_bowl[bowling_style]['matches'].add(match_id);
          }
          // Counting Balls
          if (!(ball.containsKey("extras") &&
              ball['extras'].containsKey("wides"))) {
            all_data['balls'] += 1;
            data_by_year[year]['balls'] += 1;
            data_by_match[match_id]['balls'] += 1;
            data_by_specific_bowl[bowling_style]['balls'] += 1;
          }
          // Counting Wides
          if (ball.containsKey("extras") &&
              ball['extras'].containsKey("wides")) {
            all_data['wides'] += 1;
            data_by_year[year]['wides'] += 1;
            data_by_specific_bowl[bowling_style]['wides'] += 1;
          }
          // Couting NoBalls
          if (ball.containsKey("extras") &&
              ball['extras'].containsKey("noballs")) {
            data_by_year[year]['noballs'] += 1;
            all_data['noballs'] += 1;
            data_by_specific_bowl[bowling_style]['noballs'] += 1;
          }

          // Counting Runs
          all_data['runs'] += ball['runs']['batsman'];
          data_by_year[year]['runs'] += ball['runs']['batsman'];
          data_by_match[match_id]['runs'] += ball['runs']['batsman'];
          data_by_specific_bowl[bowling_style]['runs'] +=
              ball['runs']['batsman'];

          // Counting Fours
          if (ball['runs']['batsman'] == 4) {
            all_data['fours'] += 1;
            data_by_year[year]['fours'] += 1;
            data_by_specific_bowl[bowling_style]['fours'] += 1;
          }

          // Counting Sixes
          if (ball['runs']['batsman'] == 6) {
            all_data['sixes'] += 1;
            data_by_year[year]['sixes'] += 1;
            data_by_specific_bowl[bowling_style]['sixes'] += 1;
          }

          // Counting Wickets
          if (ball.containsKey("wicket")) {
            if (["bowled", "caught", "caught and bowled", "lbw", "stumped"]
                .contains(ball['wicket']['kind'])) {
              all_data['total_wickets'] += 1;
              data_by_year[year]['wickets'] += 1;
              data_by_specific_bowl[bowling_style]['wickets'] += 1;
              if (!all_data['wickets'].containsKey(ball['wicket']['kind'])) {
                all_data['wickets'][ball['wicket']['kind']] = 1;
              } else {
                all_data["wickets"][ball['wicket']['kind']] += 1;
              }
            }
          }
        }
        // Calculating Strike Rate
        var temp = 0.0;

        for (var match in data_by_match.keys) {
          temp += data_by_match[match]['balls'] != 0
              ? (data_by_match[match]['runs'] / data_by_match[match]['balls'])
              : 0.0;
        }
        temp = (temp * 100) / data_by_match.length;
        all_data['strike_rate'] = temp;

        // Changing wickets to double for pie chart
        Map<String, double> dataMap = {};
        for (var dis in all_data['wickets'].keys) {
          dataMap[dis] = all_data['wickets'][dis].toDouble();
        }

        // Strike Rate and Batting Average each year
        var max_sr = 0.0;
        var max_avg = 0.0;
        for (var year in data_by_year.keys) {
          var temp = 0.0;
          for (var match_id in data_by_year[year]["matches"]) {
            temp += data_by_match[match_id]['balls'] != 0
                ? ((data_by_match[match_id]['runs'] * 100) /
                    data_by_match[match_id]['balls'])
                : 0.0;
          }

          data_by_year[year]['strike_rate'] =
              temp / data_by_year[year]['matches'].length;
          if (data_by_year[year]['strike_rate'] > max_sr) {
            max_sr = data_by_year[year]['strike_rate'];
          }

          data_by_year[year]['batting_avg'] = data_by_year[year]['wickets'] != 0
              ? (data_by_year[year]['runs'] / data_by_year[year]['wickets'])
              : 0.0;
          if (data_by_year[year]['batting_avg'] > max_avg) {
            max_avg = data_by_year[year]['batting_avg'];
          }
        }
        var years = data_by_year.keys.toList();
        years.sort();
        var strt_year;
        if (years.length > 7) {
          strt_year = years[years.length - 7];
        } else {
          strt_year = years[0];
        }
        all_data['matches'] = data_by_match.length;
        String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
        share_all_data(var data) {
          var output_text = widget.batsman +
              " Vs " +
              widget.bowlType +
              ' in ' +
              widget.leag +
              '\n\t';
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
          output_text += "Batting Average - ";
          output_text += data['total_wickets'] != 0
              ? (data['runs'] / data['total_wickets']).toStringAsFixed(4)
              : "NA";
          output_text += "\n\t";
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

        return SingleChildScrollView(
            child: Column(
          children: [
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Image.asset(
                                    'assets/batting.png',
                                    scale: 8,
                                  )),
                              Text(
                                widget.batsman,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.only(top: 40),
                          child: Image.asset(
                            'assets/vs.png',
                            scale: 10,
                            color: Theme.of(context).disabledColor,
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Column(children: [
                            Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Image.asset(
                                  'assets/bowling.png',
                                  scale: 7.5,
                                )),
                            Text(
                              capitalize(widget.bowlType),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ]))
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 2,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "All Stats",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          IconButton(
                              padding: EdgeInsets.all(0),
                              iconSize: 25,
                              splashRadius: 20,
                              icon: Icon(Icons.share),
                              onPressed: () async {
                                // print('something');
                                share_all_data(all_data);
                                // share_all_data(all_data);
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
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.1),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(0.8),
                        1: FlexColumnWidth(0.2),
                        2: FlexColumnWidth(0.5)
                      },
                      children: [
                        TableRow(children: [
                          TableCell(
                              child: Text(
                            'Innings',
                            style: textsyle_left,
                          )),
                          TableCell(child: Text('-')),
                          TableCell(
                              child: Text(
                            data_by_match.length.toString(),
                            style: textsyle_left,
                          ))
                        ]),
                        rowSpacer,
                        TableRow(children: [
                          TableCell(
                              child: Text(
                            'Total Runs',
                            style: textsyle_left,
                          )),
                          TableCell(child: Text('-')),
                          TableCell(
                              child: Text(
                            all_data['runs'].toString(),
                            style: textsyle_left,
                          ))
                        ]),
                        rowSpacer,
                        TableRow(children: [
                          TableCell(
                              child: Text(
                            'Total Balls',
                            style: textsyle_left,
                          )),
                          TableCell(child: Text('-')),
                          TableCell(
                              child: Text(
                            all_data['balls'].toString(),
                            style: textsyle_left,
                          ))
                        ]),
                        rowSpacer,
                        TableRow(children: [
                          TableCell(
                              child: Text(
                            'Dismissals',
                            style: textsyle_left,
                          )),
                          TableCell(child: Text('-')),
                          TableCell(
                              child: Text(
                            all_data['total_wickets'].toString(),
                            style: textsyle_left,
                          ))
                        ]),
                        rowSpacer,
                        TableRow(children: [
                          TableCell(
                              child: Text(
                            'Batting Average',
                            style: textsyle_left,
                          )),
                          TableCell(child: Text('-')),
                          TableCell(
                              child: Text(
                            all_data['total_wickets'] != 0
                                ? (all_data['runs'] / all_data['total_wickets'])
                                    .toStringAsFixed(2)
                                : "NA",
                            style: textsyle_left,
                          ))
                        ]),
                        rowSpacer,
                        TableRow(children: [
                          TableCell(
                              child: Text(
                            'Avg. Strike Rate',
                            style: textsyle_left,
                          )),
                          TableCell(child: Text('-')),
                          TableCell(
                              child: Text(
                            all_data['strike_rate'].toStringAsFixed(2),
                            style: textsyle_left,
                          ))
                        ]),
                        rowSpacer,
                        TableRow(children: [
                          TableCell(
                              child: Text(
                            'Fours',
                            style: textsyle_left,
                          )),
                          TableCell(child: Text('-')),
                          TableCell(
                              child: Text(
                            all_data['fours'].toString(),
                            style: textsyle_left,
                          ))
                        ]),
                        rowSpacer,
                        TableRow(children: [
                          TableCell(
                              child: Text(
                            'Sixes',
                            style: textsyle_left,
                          )),
                          TableCell(child: Text('-')),
                          TableCell(
                              child: Text(
                            all_data['sixes'].toString(),
                            style: textsyle_left,
                          ))
                        ]),
                        rowSpacer,
                        TableRow(children: [
                          TableCell(
                              child: Text(
                            'Wides',
                            style: textsyle_left,
                          )),
                          TableCell(child: Text('-')),
                          TableCell(
                              child: Text(
                            all_data['wides'].toString(),
                            style: textsyle_left,
                          ))
                        ]),
                        rowSpacer,
                        TableRow(children: [
                          TableCell(
                              child: Text(
                            'No Balls',
                            style: textsyle_left,
                          )),
                          TableCell(child: Text('-')),
                          TableCell(
                              child: Text(
                            all_data['noballs'].toString(),
                            style: textsyle_left,
                          ))
                        ]),
                        rowSpacer,
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
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dismissal Types",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          IconButton(
                              padding: EdgeInsets.all(0),
                              iconSize: 25,
                              splashRadius: 20,
                              icon: Icon(Icons.share),
                              onPressed: () async {
                                // print('something');
                                share_charts(
                                    key1,
                                    "Dissmissal Types of " +
                                        widget.batsman +
                                        " Vs " +
                                        widget.bowlType +
                                        " in " +
                                        widget.leag);
                                // share_all_data(all_data);
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
                    child: all_data["wickets"].length == 0
                        ? Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Text(
                              widget.batsman +
                                  " was never dissmissed by " +
                                  widget.bowlType,
                              style:
                                  TextStyle(fontSize: 17, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ))
                        : Container(
                            padding: EdgeInsets.all(20),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: PieChart(
                              dataMap: dataMap,
                              chartRadius: 300,
                              legendOptions: LegendOptions(
                                  legendPosition: LegendPosition.top,
                                  legendShape: BoxShape.rectangle,
                                  showLegendsInRow: true),
                              initialAngleInDegree: 45,
                              chartValuesOptions: ChartValuesOptions(
                                decimalPlaces: 0,
                                showChartValueBackground: true,
                                chartValueStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ))),
                Divider(
                  height: 0,
                  thickness: 2,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Strike Rate Over the Years",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          IconButton(
                              padding: EdgeInsets.all(0),
                              iconSize: 25,
                              splashRadius: 20,
                              icon: Icon(Icons.share),
                              onPressed: () async {
                                // print('something');
                                share_charts(
                                    key2,
                                    "Strike Rate Over the Years " +
                                        widget.batsman +
                                        " Vs " +
                                        widget.bowlType +
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
                Divider(
                  color: Colors.transparent,
                ),
                years.length > 7
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.swipe),
                          Text("  Swipe right or left to view more data")
                        ],
                      )
                    : SizedBox.shrink(),
                RepaintBoundary(
                    key: key2,
                    child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            height: 325,
                            padding: EdgeInsets.only(left: 10),
                            child: charts.BarChart(
                              get_strike_rate_by_year(
                                  data_by_year, data_by_match),
                              behaviors: [
                                // Adding this behavior will allow tapping a bar to center it in the viewport

                                charts.PanAndZoomBehavior(),
                              ],
                              animate: false,
                              domainAxis: charts.OrdinalAxisSpec(
                                viewport: charts.OrdinalViewport(strt_year, 7),
                                renderSpec: charts.SmallTickRendererSpec(
                                    labelStyle: charts.TextStyleSpec(
                                        color: charts.ColorUtil.fromDartColor(
                                            Theme.of(context).hintColor))),
                              ),
                              barRendererDecorator: charts.BarLabelDecorator(
                                labelPosition: charts.BarLabelPosition.inside,
                              ),
                              primaryMeasureAxis: charts.NumericAxisSpec(
                                  viewport: charts.NumericExtents(
                                      0, max_sr.ceil() + 50),
                                  tickProviderSpec:
                                      charts.BasicNumericTickProviderSpec(
                                          desiredMinTickCount: 6),
                                  renderSpec: charts.GridlineRendererSpec(
                                      lineStyle: charts.LineStyleSpec(
                                          color: charts.ColorUtil.fromDartColor(
                                              Theme.of(context).hintColor)),
                                      labelStyle: charts.TextStyleSpec(
                                        fontSize: 15,
                                        color: charts.ColorUtil.fromDartColor(
                                            Theme.of(context).hintColor),
                                      ))),
                            ),
                          )
                        ]))),
                Divider(
                  height: 0,
                  thickness: 2,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Batting Average Over the Years",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          IconButton(
                              padding: EdgeInsets.all(0),
                              iconSize: 25,
                              splashRadius: 20,
                              icon: Icon(Icons.share),
                              onPressed: () async {
                                // print('something');
                                share_charts(
                                    key3,
                                    "Batting Average Over the Years " +
                                        widget.batsman +
                                        " Vs " +
                                        widget.bowlType +
                                        " in " +
                                        widget.leag);
                                // share_all_data(all_data);
                              })
                        ])),
                Divider(
                  height: 0,
                  thickness: 3,
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Divider(
                  color: Colors.transparent,
                ),
                years.length > 7
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.swipe),
                          Text("  Swipe right or left to view more data")
                        ],
                      )
                    : SizedBox.shrink(),
                RepaintBoundary(
                    key: key3,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      height: 300,
                      padding: EdgeInsets.only(left: 10),
                      child: charts.BarChart(
                        get_avg_data_for_chart(data_by_year),
                        animate: false,
                        behaviors: [
                          charts.PanAndZoomBehavior(),
                        ],
                        domainAxis: charts.OrdinalAxisSpec(
                          viewport: charts.OrdinalViewport(strt_year, 7),
                          renderSpec: charts.SmallTickRendererSpec(
                              labelStyle: charts.TextStyleSpec(
                                  color: charts.ColorUtil.fromDartColor(
                                      Theme.of(context).hintColor))),
                        ),
                        barRendererDecorator: charts.BarLabelDecorator(
                          labelPosition: charts.BarLabelPosition.inside,
                        ),
                        primaryMeasureAxis: charts.NumericAxisSpec(
                            viewport: charts.NumericExtents(0, max_avg.ceil()),
                            tickProviderSpec:
                                charts.BasicNumericTickProviderSpec(
                                    desiredMinTickCount: 6),
                            renderSpec: charts.GridlineRendererSpec(
                                lineStyle: charts.LineStyleSpec(
                                    color: charts.ColorUtil.fromDartColor(
                                        Theme.of(context).hintColor)),
                                labelStyle: charts.TextStyleSpec(
                                  fontSize: 15,
                                  color: charts.ColorUtil.fromDartColor(
                                      Theme.of(context).hintColor),
                                ))),
                      ),
                    )),
                Divider(
                  height: 0,
                  thickness: 2,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Data By Specific Bowling Type",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ])),
                Divider(
                  height: 0,
                  thickness: 3,
                ),
                Divider(
                  color: Colors.transparent,
                ),
              ] +
              get_data_each_style_widgets(data_by_specific_bowl, context) +
              [
                Divider(
                  height: 0,
                  thickness: 2,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Data By Year",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ])),
                Divider(
                  height: 0,
                  thickness: 3,
                ),
                Divider(
                  color: Colors.transparent,
                ),
              ] +
              get_data_each_year_widgets(data_by_year, context),
        ));
      }),
    );
  }
}
