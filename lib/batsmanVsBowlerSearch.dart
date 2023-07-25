import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'BatsmanVsBowlInfo.dart';
import 'loading.dart';
import 'error.dart';
import 'package:http/http.dart' as http;
import 'constants.dart' as Constants;
import 'dart:convert';
import 'services.dart';

class BatVsBowlSearch extends StatefulWidget {
  final leag;
  BatVsBowlSearch(this.leag, {Key key}) : super(key: key);
  @override
  _BatVsBowlSearchState createState() => _BatVsBowlSearchState();
}

class _BatVsBowlSearchState extends State<BatVsBowlSearch> {
  Map<String, String> pop_names = {};
  var batsman = '';
  var bowler = '';
  var player_list;

  Future get_pop_names() async {
    final response = await getPopNamesFromAPI();
    var temp = [];
    if (response.statusCode == 200) {
      var res_body = response.body;
      var parsed = jsonDecode(res_body);

      parsed.forEach((player) {
        var player_dict = Map<String, String>.from(player);

        pop_names[player_dict['popular_name']] = player_dict['name'];
        temp.add(player_dict['popular_name']);
      });
      player_list = List<String>.from(temp);
    } else {
      throw Exception('Failed to load');
    }
    return pop_names;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Players"),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Error());
          }
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return Center(child: Loading());
            case ConnectionState.none:
              return Center(child: Error());
            case ConnectionState.done:
              return ListView(
                children: [
                  Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "Batsman",
                        style: Theme.of(context).textTheme.headline6,
                      )),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: SearchField(
                          suggestions: player_list,
                          hasOverlay: false,
                          searchInputDecoration:
                              InputDecoration(border: OutlineInputBorder()),
                          maxSuggestionsInViewPort: 7,
                          hint: "Search Batsman",
                          onTap: (value) {
                            batsman = pop_names[value];
                          })),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "Bowler",
                        style: Theme.of(context).textTheme.headline6,
                      )),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: SearchField(
                        hint: "Search Bowler",
                        maxSuggestionsInViewPort: 7,
                        searchInputDecoration:
                            InputDecoration(border: OutlineInputBorder()),
                        suggestions: player_list,
                        hasOverlay: false,
                        onTap: (value) {
                          bowler = pop_names[value];
                        },
                      )),
                  Container(
                      margin: EdgeInsets.all(30),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(15)),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).buttonColor)),
                          onPressed: () async{
                            if (batsman == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Please select a batsman")));
                            } else if (bowler == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Please select a bowler")));
                            } else {
                              var response =
                                  await getBatsmanVsBowlerData(batsman, bowler);
                              if (response.statusCode == 200) {
                                var res_body = response.body;
                                print(res_body.runtimeType);
                                  var parsed = jsonDecode(res_body);
                                if (parsed == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "These players have never face off")));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BatsVsBowlInfo(
                                              parsed, batsman, bowler)));
                                }
                              } else {
                                throw Exception('Failed to load');
                              }
                             
                            }
                          },
                          child: Text(
                            "Get Data",
                            style: Theme.of(context).textTheme.button,
                          )))
                ],
              );
            case ConnectionState.waiting:
              return Center(child: Loading());
          }
          return Center(child: Loading());;
        },
        future: get_pop_names(),
      ),
    );
  }
}
