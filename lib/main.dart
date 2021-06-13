import 'package:cricket_statistics/batsmanVsBowlerSearch.dart';
import 'package:flutter/material.dart';
import 'stadium_search.dart';
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
      // textTheme: TextTheme(headline6: TextStyle(color: Colors.blue))),
      darkTheme: ThemeData(brightness: Brightness.dark),
      // textTheme: TextTheme(headline6: TextStyle(color: Colors.white))),
      themeMode: ThemeMode.dark,
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).buttonColor)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StadiumSearch()));
              },
              child: Text(
                'Stadium Info',
                style: Theme.of(context).textTheme.button,
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).buttonColor)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BatVsBowlSearch('ipl')));
                },
                child: Text(
                  "Batsman Vs Bowler",
                  style: Theme.of(context).textTheme.button,
                )),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).buttonColor)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BatsmanVsTeam('ipl')));
                },
                child: Text(
                  "Batsman Vs Team",
                  style: Theme.of(context).textTheme.button,
                )),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).buttonColor)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BowlerVsTeam('ipl')));
                },
                child: Text(
                  "Bowler Vs Team",
                  style: Theme.of(context).textTheme.button,
                ))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
