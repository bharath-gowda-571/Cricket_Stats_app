import 'package:flutter/material.dart';

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

class _BowlerVsTeamInfoState extends State<BowlerVsTeamInfo> {
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
            'economy': 0
          };
          for (var innings in widget.bowlVsTeam) {
            // print(innings);
            all_data['runs'] += innings['runs'];
            all_data['balls'] += innings['balls'];
            all_data['4s'] += innings['4s'];
            all_data['6s'] += innings['6s'];
            all_data['wickets'] += innings['wickets'];
            all_data['wides'] += innings['wides'];
            all_data['noballs'] += innings['noballs'];
            all_data['economy'] += innings['economy'];
          }
          all_data['economy'] /= widget.bowlVsTeam.length;
          all_data['overs'] = (all_data['balls'] / 6).toStringAsFixed(0) +
              "." +
              (all_data['balls'] % 6).toString();
          print(all_data);
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
                                    'assets/bowling.png',
                                    scale: 6.5,
                                  )),
                              Text(
                                widget.bowler,
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
                                print('something');
                                // share_all_data_text(all_data);
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
                          TableCell(child: Text('Overs', style: textsyle_left)),
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
                      ],
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
