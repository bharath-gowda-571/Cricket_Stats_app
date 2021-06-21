// import 'dart:html';
import 'dart:math';

import 'package:cricket_statistics/batsmanVsTeamInfo.dart';
import 'package:flutter/material.dart';
import 'random_ops.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:share/share.dart';

class BowlerVsTeamInfo extends StatefulWidget {
  // const BowlerVsTeamInfo({Key? key}) : super(key: key);
  final bowlVsTeam;
  final bowler;
  final team;
  final leag;
  BowlerVsTeamInfo(this.bowlVsTeam, this.bowler, this.team, this.leag,
      {Key key})
      : super(key: key);
  @override
  _BowlerVsTeamInfoState createState() => _BowlerVsTeamInfoState();
}

class EconomyRate {
  final String year;
  final double economy;
  EconomyRate(this.year, this.economy);
}

class _BowlerVsTeamInfoState extends State<BowlerVsTeamInfo> {
  GlobalKey key1 = GlobalKey();
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
  getData(var data_by_y) {
    List<EconomyRate> data = [];
    var keys = data_by_y.keys.toList();
    keys.sort();
    for (var i in keys) {
      data.add(EconomyRate(i, data_by_y[i]['economy']));
    }
    return [
      charts.Series<EconomyRate, String>(
          id: "Economy Rate",
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (EconomyRate ec, __) => ec.year,
          measureFn: (EconomyRate ec, __) => ec.economy,
          labelAccessorFn: (EconomyRate ec, __) =>
              ec.economy.toStringAsFixed(2),
          data: data)
    ];
  }

  List<Widget> get_data_each_year_widget(data_by_y, context) {
    List<Widget> lis = [];
    var keys = data_by_y.keys.toList();
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
                    'Overs',
                    style: textsyle_left,
                  )),
                  TableCell(child: Text('-')),
                  TableCell(
                      child: Text(
                    data_by_y[i]['overs'],
                    style: textsyle_left,
                  ))
                ]),
                rowSpacer,
                TableRow(children: [
                  TableCell(
                      child: Text(
                    'Economy',
                    style: textsyle_left,
                  )),
                  TableCell(child: Text('-')),
                  TableCell(
                      child: Text(
                    data_by_y[i]['economy'].toStringAsFixed(2),
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
                    data_by_y[i]['4s'].toString(),
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
                    data_by_y[i]['6s'].toString(),
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
                TableRow(children: [
                  TableCell(
                      child: Text(
                    'Best Figures',
                    style: textsyle_left,
                  )),
                  TableCell(child: Text('-')),
                  TableCell(
                      child: Text(
                    data_by_y[i]['best figures']['wickets'].toString() +
                        " - " +
                        data_by_y[i]['best figures']['runs'].toString() +
                        " (" +
                        data_by_y[i]['economy'].toStringAsFixed(2) +
                        ")",
                    style: textsyle_left,
                  ))
                ]),
                rowSpacer,
              ],
            ),
          )
        ],
      ));
    }
    return lis;
  }

  share_all_text_data(data) {
    var output_text = '';
    output_text +=
        widget.bowler + " Vs " + widget.team + " in " + widget.leag + '\n\t';
    output_text += "Innings - ";
    output_text += widget.bowlVsTeam.length.toString() + '\n\t';
    output_text += "Wickets - ";
    output_text += data['wickets'].toString() + '\n\t';
    output_text += "Total Runs - ";
    output_text += data['runs'].toString() + '\n\t';
    output_text += "Total Balls - ";
    output_text += data['balls'].toString() + '\n\t';
    output_text += "Overs - ";
    output_text += data['overs'] + '\n\t';
    output_text += "Economy - ";
    output_text += data['economy'].toStringAsFixed(4) + '\n\t';
    output_text += "Fours - ";
    output_text += data['4s'].toString() + '\n\t';
    output_text += "Sixes - ";
    output_text += data['6s'].toString() + '\n\t';
    output_text += "Wides - ";
    output_text += data['wides'].toString() + '\n\t';
    output_text += "No Balls - ";
    output_text += data['noballs'].toString() + '\n\t';
    output_text += "Best Figures - ";
    output_text += data['best figures']['wickets'].toString() +
        " - " +
        data['best figures']['runs'].toString() +
        " (" +
        data['economy'].toStringAsFixed(2) +
        ")";
    Share.share(output_text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bowler vs Team"),
      ),
      body: Builder(
        builder: (BuildContext context) {
          // print(widget.bowlVsTeam);
          Map<String, dynamic> all_data = {
            'overs': '',
            'runs': 0,
            'balls': 0,
            'wickets': 0,
            'noballs': 0,
            '4s': 0,
            '6s': 0,
            'wides': 0,
            'noballs': 0,
            'economy': 0,
            'best figures': {
              'wickets': widget.bowlVsTeam[0]['wickets'],
              'runs': widget.bowlVsTeam[0]['runs'],
              'economy': widget.bowlVsTeam[0]['economy']
            }
          };
          var data_by_year = {};
          // print(all_data);
          for (var innings in widget.bowlVsTeam) {
            var year = innings['year'];
            if (!data_by_year.containsKey(year)) {
              data_by_year[year] = {
                'overs': '',
                'runs': 0,
                'balls': 0,
                'wickets': 0,
                'noballs': 0,
                '4s': 0,
                '6s': 0,
                'wides': 0,
                'noballs': 0,
                'economy': 0,
                'matches': [],
                'best figures': {
                  'wickets': innings['wickets'],
                  'runs': innings['runs'],
                  'economy': innings['economy']
                }
              };
            }
            if (!data_by_year[year]['matches'].contains(innings['match_id'])) {
              data_by_year[year]['matches'].add(innings['match_id']);
            }
            all_data['runs'] += innings['runs'];
            data_by_year[year]['runs'] += innings['runs'];
            all_data['balls'] += innings['balls'];
            data_by_year[year]['balls'] += innings['balls'];
            all_data['4s'] += innings['4s'];
            data_by_year[year]['4s'] += innings['4s'];
            all_data['6s'] += innings['6s'];
            data_by_year[year]['6s'] += innings['6s'];
            all_data['wickets'] += innings['wickets'];
            data_by_year[year]['wickets'] += innings['wickets'];
            all_data['wides'] += innings['wides'];
            data_by_year[year]['wides'] += innings['wides'];
            all_data['noballs'] += innings['noballs'];
            data_by_year[year]['noballs'] += innings['noballs'];

            all_data['economy'] += innings['economy'];
            data_by_year[year]['economy'] += innings['economy'];

            var temp =
                get_better_bowling_figures(all_data['best figures'], innings);
            all_data['best figures']['runs'] = temp['runs'];
            all_data['best figures']['wickets'] = temp['wickets'];
            all_data['best figures']['economy'] = temp['economy'];

            var temp2 = get_better_bowling_figures(
                data_by_year[year]['best figures'], innings);
            data_by_year[year]['best figures']['runs'] = temp2['runs'];
            data_by_year[year]['best figures']['wickets'] = temp2['wickets'];
            data_by_year[year]['best figures']['economy'] = temp2['economy'];
          }
          all_data['economy'] /= widget.bowlVsTeam.length;
          all_data['overs'] = (all_data['balls'] / 6).toStringAsFixed(0) +
              "." +
              (all_data['balls'] % 6).toString();
          var max_eco = 0.0;
          for (var year in data_by_year.keys) {
            data_by_year[year]['economy'] /=
                data_by_year[year]['matches'].length;
            data_by_year[year]['overs'] =
                (data_by_year[year]['balls'] / 6).toStringAsFixed(0) +
                    "." +
                    (data_by_year[year]['balls'] % 6).toString();

            if (data_by_year[year]['economy'] > max_eco) {
              max_eco = data_by_year[year]['economy'];
            }
          }
          // print(data_by_year);
          var years = data_by_year.keys.toList();
          years.sort();
          var strt_year = '';
          if (years.length > 7) {
            strt_year = years[years.length - 7];
          } else {
            strt_year = years[0];
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
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      child: Image.asset(
                                        'assets/bowling.png',
                                        scale: 7,
                                      )),
                                  Text(
                                    widget.bowler,
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
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
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
                                    // print('something');
                                    share_all_text_data(all_data);
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
                                widget.bowlVsTeam.length.toString(),
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
                                all_data['wickets'].toString(),
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
                                  child: Text('Overs', style: textsyle_left)),
                              TableCell(child: Text('-')),
                              TableCell(
                                  child: Text(
                                all_data['overs'],
                                style: textsyle_left,
                              ))
                            ]),
                            rowSpacer,
                            TableRow(children: [
                              TableCell(
                                  child: Text(
                                'Economy',
                                style: textsyle_left,
                              )),
                              TableCell(child: Text('-')),
                              TableCell(
                                  child: Text(
                                all_data['economy'].toStringAsFixed(2),
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
                                all_data['4s'].toString(),
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
                                all_data['6s'].toString(),
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
                            TableRow(children: [
                              TableCell(
                                  child: Text(
                                'Best Figures',
                                style: textsyle_left,
                              )),
                              TableCell(child: Text('-')),
                              TableCell(
                                  child: Text(
                                all_data['best figures']['wickets'].toString() +
                                    " - " +
                                    all_data['best figures']['runs']
                                        .toString() +
                                    " (" +
                                    all_data['economy'].toStringAsFixed(2) +
                                    ")",
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
                        height: 50,
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Average Economy Over the Years",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              IconButton(
                                  padding: EdgeInsets.all(0),
                                  iconSize: 25,
                                  splashRadius: 20,
                                  icon: Icon(Icons.share),
                                  onPressed: () async {
                                    // print('something 2');
                                    share_charts(
                                        key1,
                                        widget.bowler +
                                            " Vs " +
                                            widget.team +
                                            " in " +
                                            widget.leag +
                                            "\n" +
                                            "Average Economy Over The Years");
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
                            getData(data_by_year),
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
                                    charts.NumericExtents(0, max_eco.ceil()),
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
                  get_data_each_year_widget(data_by_year, context),
            ),
          );
        },
      ),
    );
  }
}
