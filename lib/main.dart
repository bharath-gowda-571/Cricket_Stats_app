import 'package:cricket_statistics/batsmanVsBowlerSearch.dart';
import 'package:flutter/material.dart';
import 'batsmanVsTeamSearch.dart';
import 'bowlerVsTeamSearch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(brightness: Brightness.light, primaryColor: Colors.grey),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.light,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // ElevatedButton(
            //   style: ButtonStyle(
            //       backgroundColor:
            //           MaterialStateProperty.all(Theme.of(context).buttonColor)),
            //   onPressed: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => StadiumSearch()));
            //   },
            //   child: Text(
            //     'Stadium Info',
            //     style: Theme.of(context).textTheme.button,
            //   ),
            // ),
            Divider(
              color: Colors.transparent,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05),
                height: 150,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).buttonColor)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BatVsBowlSearch('ipl')));
                    },
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/batting.png',
                                scale: 7,
                              ),
                              Text(
                                "Batsman",
                                style: Theme.of(context).textTheme.headline5,
                              )
                            ],
                          ),
                          Image.asset(
                            "assets/vs.png",
                            scale: 9,
                            color: Theme.of(context).hintColor,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/bowling.png',
                                scale: 5.75,
                              ),
                              Text(
                                " Bowler",
                                style: Theme.of(context).textTheme.headline5,
                              )
                            ],
                          ),
                        ]))),
            Divider(
              color: Colors.transparent,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05),
                height: 150,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).buttonColor)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BatsmanVsTeam('ipl')));
                    },
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/batting.png',
                                scale: 7,
                              ),
                              Text(
                                "Batsman",
                                style: Theme.of(context).textTheme.headline5,
                              )
                            ],
                          ),
                          Image.asset(
                            "assets/vs.png",
                            scale: 9,
                            color: Theme.of(context).hintColor,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/team.png',
                                scale: 6,
                              ),
                              Text(
                                "Team",
                                style: Theme.of(context).textTheme.headline5,
                              )
                            ],
                          ),
                        ]))),
            Divider(
              color: Colors.transparent,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05),
                height: 150,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).buttonColor)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BowlerVsTeam('ipl')));
                    },
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/bowling.png',
                                scale: 5.75,
                              ),
                              Text(
                                "Bowler ",
                                style: Theme.of(context).textTheme.headline5,
                              )
                            ],
                          ),
                          Image.asset(
                            "assets/vs.png",
                            scale: 9,
                            color: Theme.of(context).hintColor,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/team.png',
                                scale: 6,
                              ),
                              Text(
                                "Team",
                                style: Theme.of(context).textTheme.headline5,
                              )
                            ],
                          ),
                        ])))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
