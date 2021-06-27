// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:share/share.dart';
import 'random_ops.dart';
import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

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

class BatsmanVsTeamInfo extends StatefulWidget {
  final batVsTeam;
  final batsman;
  final team;
  final leag;
  BatsmanVsTeamInfo(this.batVsTeam, this.batsman, this.team, this.leag,
      {Key key})
      : super(key: key);
  @override
  _BatsmanVsTeamInfoState createState() => _BatsmanVsTeamInfoState();
}

// List<int> strike_rates = [];

class _BatsmanVsTeamInfoState extends State<BatsmanVsTeamInfo> {
  double max_sr = 0;
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();

  get_strike_rate_by_year(var data_by_y, data_by_match) {
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
      if (sr > max_sr) {
        max_sr = sr;
      }
      data_by_y[i]['strike rate'] = sr;
      var col;
      if (data_by_y[i]['total balls'] < 6) {
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

  List<Widget> get_data_each_year_widgets(var data_by_y, context) {
    // print(data_by_y);
    List<Widget> lis = [];
    var keys = data_by_y.keys.toList();
    keys.sort();
    for (var i in keys) {
      data_by_y[i]['positions'].sort();
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
                        data_by_y[i]['total runs'].toString(),
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
                        data_by_y[i]['total balls'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Dissmissed',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['dissmissed'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text('Batting Average', style: textsyle_left)),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['dissmissed'] != 0
                            ? (data_by_y[i]['total runs'] /
                                    data_by_y[i]['dissmissed'])
                                .toStringAsFixed(2)
                            : "NA",
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Avg Strike Rate',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['strike rate'].toStringAsFixed(2),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Fours:',
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
                        data_by_y[i]['sixes'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Batting Positions',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['positions'].join(', '),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Highest Score',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['highest score']['runs'].toString() +
                            '(' +
                            data_by_y[i]['highest score']['balls'].toString() +
                            ')' +
                            (data_by_y[i]['highest score']['status'] ==
                                    "not out"
                                ? "*"
                                : ' '),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        'Ducks',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['ducks'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        '30s',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['30s'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        '50s',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['50s'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer,
                    TableRow(children: [
                      TableCell(
                          child: Text(
                        '100s',
                        style: textsyle_left,
                      )),
                      TableCell(child: Text('-')),
                      TableCell(
                          child: Text(
                        data_by_y[i]['100s'].toString(),
                        style: textsyle_left,
                      ))
                    ]),
                    rowSpacer
                  ],
                ))
          ]));
    }
    return lis;
  }

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
  get_avg_data_for_chart(var data_by_y) {
    List<AverageRuns> data = [];
    var keys = data_by_y.keys.toList();
    keys.sort();
    for (var i in keys) {
      var avg = data_by_y[i]['dissmissed'] != 0
          ? (data_by_y[i]['total runs'] / data_by_y[i]['dissmissed'])
          : 0.0;
      // if (avg == 0) {
      //   continue;
      // }
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

  share_all_data_text(data) {
    var output_text = '';
    output_text +=
        widget.batsman + " Vs " + widget.team + " in " + widget.leag + '\n\t';
    output_text += "Innings - ";
    output_text += widget.batVsTeam.length.toString();
    output_text += '\n\t';
    output_text += "Total Runs - ";
    output_text += data['total runs'].toString();
    output_text += '\n\t';
    output_text += "Total Balls - ";
    output_text += data['total balls'].toString();
    output_text += '\n\t';
    output_text += "Dissmissed - ";
    output_text += data['dissmissed'].toString();
    output_text += '\n\t';
    output_text += "Batting Average - ";
    output_text +=
        (data['total runs'] / widget.batVsTeam.length).toStringAsFixed(4);
    output_text += '\n\t';

    output_text += "Average Strike Rate - ";
    output_text += data['strike_rate'].toStringAsFixed(4);
    output_text += '\n\t';

    output_text += "Fours - ";
    output_text += data['fours'].toString();
    output_text += '\n\t';

    output_text += "Sixes -  ";
    output_text += data['sixes'].toString();
    output_text += '\n\t';

    output_text += "Batting Positions - ";
    output_text += data['positions'].join(', ');
    output_text += '\n\t';

    output_text += "Highest Score - ";
    output_text += data['highest score']['runs'].toString() +
        '(' +
        data['highest score']['balls'].toString() +
        ')' +
        (data['highest score']['status'] == "not out" ? "*" : ' ');
    output_text += '\n\t';

    output_text += "Ducks - ";
    output_text += data['ducks'].toString();
    output_text += '\n\t';

    output_text += "30s - ";
    output_text += data['30s'].toString();
    output_text += '\n\t';

    output_text += "50s - ";
    output_text += data['50s'].toString();
    output_text += '\n\t';

    output_text += "100s - ";
    output_text += data['100s'].toString();

    Share.share(output_text);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data_by_match = {};
    Map<String, dynamic> data_by_year = {};

    return Scaffold(
      appBar: AppBar(
        title: Text('Batsman vs Team'),
      ),
      body: Builder(builder: (BuildContext context) {
        all_data = {
          "total runs": 0,
          'total balls': 0,
          'avg strike rate': 0,
          'dissmissed': 0,
          'fours': 0,
          'sixes': 0,
          'ducks': 0,
          '50s': 0,
          '100s': 0,
          '30s': 0,
          'positions': [],
          'highest score': {'runs': 0, 'balls': 0, 'status': ''}
        };

        all_data['highest score']['runs'] = widget.batVsTeam[0]['runs'];
        all_data['highest score']['balls'] = widget.batVsTeam[0]['balls'];
        all_data['highest score']['status'] = widget.batVsTeam[0]['status'];

        var temp = 0.0;
        for (var i in widget.batVsTeam) {
          var year = i['year'];
          if (!data_by_year.containsKey(year)) {
            data_by_year[year] = {
              "total runs": 0,
              'total balls': 0,
              'avg strike rate': 0,
              'fours': 0,
              'sixes': 0,
              'ducks': 0,
              '50s': 0,
              '100s': 0,
              '30s': 0,
              "dissmissed": 0,
              'positions': [],
              'matches': [],
              'highest score': {
                'runs': i['runs'],
                'balls': i['balls'],
                'status': i['status']
              }
            };
          }
          // Counting Dissmissed
          if (i['status'] == 'out') {
            all_data['dissmissed'] += 1;
            data_by_year[year]['dissmissed'] += 1;
          }
          // Counting Ducks
          if (i['runs'] == 0 && i['status'] == 'out') {
            all_data['ducks'] += 1;
            data_by_year[year]['ducks'] += 1;
          }
          if (i['runs'] >= 30 && i['runs'] < 50) {
            all_data['30s'] += 1;
            data_by_year[year]['30s'] += 1;
          } else if (i['runs'] >= 50 && i['runs'] < 100) {
            all_data['50s'] += 1;
            data_by_year[year]['50s'] += 1;
          } else if (i['runs'] >= 100) {
            all_data['100s'] += 1;
            data_by_year[year]['100s'] += 1;
          }
          all_data['total runs'] += i['runs'];
          all_data['total balls'] += i['balls'];
          temp += i['balls'] == 0 ? 0.0 : (i['runs'] * 100) / i['balls'];
          all_data['fours'] += i['4s'];
          all_data['sixes'] += i['6s'];
          data_by_year[year]['total runs'] += i['runs'];
          data_by_year[year]['total balls'] += i['balls'];
          data_by_year[year]['fours'] += i['4s'];
          data_by_year[year]['sixes'] += i['6s'];

          if (!data_by_year[year]['positions'].contains(i['position'])) {
            data_by_year[year]['positions'].add(i['position']);
          }
          data_by_match[i['match_id']] = i;

          data_by_year[year]['matches'].add(i['match_id']);
          if (!all_data['positions'].contains(i['position'])) {
            all_data['positions'].add(i['position']);
          }
          var high = (get_better_batsman_score(i, all_data['highest score']));

          all_data['highest score']['runs'] = high['runs'];
          all_data['highest score']['balls'] = high['balls'];
          all_data['highest score']['status'] = high['status'];

          var high2 =
              get_better_batsman_score(i, data_by_year[year]['highest score']);

          data_by_year[year]['highest score']['runs'] = high2['runs'];
          data_by_year[year]['highest score']['balls'] = high2['balls'];
          data_by_year[year]['highest score']['status'] = high2['status'];
        }
        all_data['positions'].sort();

        all_data['strike_rate'] = temp / widget.batVsTeam.length;

        var years = data_by_year.keys.toList();
        years.sort();
        var strt_year;
        if (years.length > 7) {
          strt_year = years[years.length - 7];
        } else {
          strt_year = years[0];
        }
        // get max avg runs
        var max_avg = 0.0;
        for (var i in years) {
          var cur_avg;
          cur_avg = data_by_year[i]['dissmissed'] != 0
              ? data_by_year[i]['total runs'] / data_by_year[i]['dissmissed']
              : 1.0;
          if (cur_avg > max_avg) {
            max_avg = cur_avg;
          }
        }
        var temp2 = get_strike_rate_by_year(data_by_year, data_by_match);

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
                                  margin: EdgeInsets.only(top: 2, bottom: 2),
                                  child: Image.asset(
                                    'assets/team.png',
                                    scale: 6.5,
                                  )),
                              Text(
                                widget.team,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
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
                                  // this the chart to render

                                  share_all_data_text(all_data);
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
                              widget.batVsTeam.length.toString(),
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
                              all_data['total runs'].toString(),
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
                              all_data['total balls'].toString(),
                              style: textsyle_left,
                            ))
                          ]),
                          rowSpacer,
                          TableRow(children: [
                            TableCell(
                                child: Text(
                              'Dissmissed',
                              style: textsyle_left,
                            )),
                            TableCell(child: Text('-')),
                            TableCell(
                                child: Text(
                              all_data['dissmissed'].toString(),
                              style: textsyle_left,
                            ))
                          ]),
                          rowSpacer,
                          TableRow(children: [
                            TableCell(
                                child: Text('Batting Average',
                                    style: textsyle_left)),
                            TableCell(child: Text('-')),
                            TableCell(
                                child: Text(
                              all_data['dissmissed'] != 0
                                  ? (all_data['total runs'] /
                                          all_data['dissmissed'])
                                      .toStringAsFixed(2)
                                  : "NA",
                              style: textsyle_left,
                            ))
                          ]),
                          rowSpacer,
                          TableRow(children: [
                            TableCell(
                                child: Text(
                              'Avg Strike Rate',
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
                              'Batting Positions',
                              style: textsyle_left,
                            )),
                            TableCell(child: Text('-')),
                            TableCell(
                                child: Text(
                              all_data['positions'].join(', '),
                              style: textsyle_left,
                            ))
                          ]),
                          rowSpacer,
                          TableRow(children: [
                            TableCell(
                                child: Text(
                              'Highest Score',
                              style: textsyle_left,
                            )),
                            TableCell(child: Text('-')),
                            TableCell(
                                child: Text(
                              all_data['highest score']['runs'].toString() +
                                  '(' +
                                  all_data['highest score']['balls']
                                      .toString() +
                                  ')' +
                                  (all_data['highest score']['status'] ==
                                          "not out"
                                      ? "*"
                                      : ' '),
                              style: textsyle_left,
                            ))
                          ]),
                          rowSpacer,
                          TableRow(children: [
                            TableCell(
                                child: Text(
                              'Ducks',
                              style: textsyle_left,
                            )),
                            TableCell(child: Text('-')),
                            TableCell(
                                child: Text(
                              all_data['ducks'].toString(),
                              style: textsyle_left,
                            ))
                          ]),
                          rowSpacer,
                          TableRow(children: [
                            TableCell(
                                child: Text(
                              '30s',
                              style: textsyle_left,
                            )),
                            TableCell(child: Text('-')),
                            TableCell(
                                child: Text(
                              all_data['30s'].toString(),
                              style: textsyle_left,
                            ))
                          ]),
                          rowSpacer,
                          TableRow(children: [
                            TableCell(
                                child: Text(
                              '50s',
                              style: textsyle_left,
                            )),
                            TableCell(child: Text('-')),
                            TableCell(
                                child: Text(
                              all_data['50s'].toString(),
                              style: textsyle_left,
                            ))
                          ]),
                          rowSpacer,
                          TableRow(children: [
                            TableCell(
                                child: Text(
                              '100s',
                              style: textsyle_left,
                            )),
                            TableCell(child: Text('-')),
                            TableCell(
                                child: Text(
                              all_data['100s'].toString(),
                              style: textsyle_left,
                            ))
                          ]),
                          rowSpacer
                        ],
                      )),
                  Divider(
                    height: 0,
                    thickness: 2,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 50,
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.only(top: 0, bottom: 0, left: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Text(
                              "Batting Average Over the Years",
                              style: Theme.of(context).textTheme.headline6,
                            )),
                            IconButton(
                                padding: EdgeInsets.all(0),
                                iconSize: 25,
                                splashRadius: 20,
                                icon: Icon(Icons.share),
                                onPressed: () async {
                                  share_charts(
                                      key1,
                                      "Batting Average Over Years\n" +
                                          widget.batsman +
                                          " Vs " +
                                          widget.team +
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
                      key: key1,
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        height: 300,
                        padding: EdgeInsets.only(left: 10, right: 5),
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
                              viewport:
                                  charts.NumericExtents(0, max_avg.ceil()),
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
                    color: Colors.transparent,
                  ),
                  Divider(
                    height: 0,
                    thickness: 2,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.only(top: 0, bottom: 0, left: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Text(
                              "Strike Rate Over the Years",
                              style: Theme.of(context).textTheme.headline6,
                            )),
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
                                          widget.team +
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
                  years.length > 7
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.swipe),
                            Text("  Swipe right or left to view more data")
                          ],
                        )
                      : SizedBox.shrink(),
                  Divider(
                    color: Colors.transparent,
                  ),
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
                              padding: EdgeInsets.only(left: 10, right: 5),
                              child: charts.BarChart(
                                get_strike_rate_by_year(
                                    data_by_year, data_by_match),
                                behaviors: [
                                  // Adding this behavior will allow tapping a bar to center it in the viewport

                                  charts.PanAndZoomBehavior(),
                                ],
                                animate: false,
                                domainAxis: charts.OrdinalAxisSpec(
                                  viewport:
                                      charts.OrdinalViewport(strt_year, 7),
                                  renderSpec: charts.SmallTickRendererSpec(
                                      labelStyle: charts.TextStyleSpec(
                                          color: charts.ColorUtil.fromDartColor(
                                              Theme.of(context).hintColor))),
                                ),
                                barRendererDecorator: charts.BarLabelDecorator(
                                  labelPosition: charts.BarLabelPosition.inside,
                                ),
                                primaryMeasureAxis: charts.NumericAxisSpec(
                                    viewport:
                                        charts.NumericExtents(0, max_sr.ceil()),
                                    tickProviderSpec:
                                        charts.BasicNumericTickProviderSpec(
                                            desiredMinTickCount: 6),
                                    renderSpec: charts.GridlineRendererSpec(
                                        lineStyle: charts.LineStyleSpec(
                                            color:
                                                charts.ColorUtil.fromDartColor(
                                                    Theme.of(context)
                                                        .hintColor)),
                                        labelStyle: charts.TextStyleSpec(
                                          fontSize: 15,
                                          color: charts.ColorUtil.fromDartColor(
                                              Theme.of(context).hintColor),
                                        ))),
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
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
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
                get_data_each_year_widgets(data_by_year, context),
          ),
        );
      }),
    );
  }
}
