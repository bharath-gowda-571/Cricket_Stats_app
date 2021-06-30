import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  // const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Info Page"),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    child: Text(
                      "Report a mistake in Data",
                      style: Theme.of(context).textTheme.headline5,
                    )),
                ElevatedButton(
                    onPressed: () {
                      return launch("https://forms.gle/4n5F6eFYdHCgFDiL7");
                    },
                    child: Text("Click This")),
                Container(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    child: Text(
                      "Feedback or Suggestion",
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.left,
                    )),
                ElevatedButton(
                    onPressed: () {
                      return launch("https://forms.gle/PNnKRHS7WcdnwbVx8");
                    },
                    child: Text("Click This")),
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
                    height: 50,
                    padding: EdgeInsets.only(top: 0, bottom: 0, left: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Text(
                            "Formulas Used",
                            style: Theme.of(context).textTheme.headline6,
                          )),
                        ])),
                Divider(
                  height: 0,
                  thickness: 3,
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    " 1. Batting Average",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Image.asset(
                  "assets/batting_avg_formula.png",
                  color: Theme.of(context).hintColor,
                  scale: 2,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    " 2. Strike Rate",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Image.asset(
                  "assets/strike_rate_formula.png",
                  color: Theme.of(context).hintColor,
                  scale: 2.5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    " 3. Average Strike Rate",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Image.asset(
                  "assets/aver_strike_rate_formula.png",
                  color: Theme.of(context).hintColor,
                  scale: 1.5,
                )
              ],
            ),
          ),
        ));
  }
}
