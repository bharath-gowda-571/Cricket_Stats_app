// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:searchfield/searchfield.dart';
// import 'stadium_info_page.dart';

// class StadiumSearch extends StatefulWidget {
//   @override
//   _StadiumSearchState createState() => _StadiumSearchState();
// }

// class _StadiumSearchState extends State<StadiumSearch> {
//   final db = FirebaseDatabase.instance.reference();
//   var stadium_data = {};
//   // List<String> cities = [];
//   List<String> cities;
//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   db.child('ipl').child('stadiums').once().then((DataSnapshot snapshot) {
//   //     stadium_data = snapshot.value;
//   //     // print(stadium_data.keys);
//   //     print('here');
//   //     var temp = stadium_data.keys.toList();
//   //     cities = List<String>.from(temp);
//   //     print(cities.runtimeType);
//   //   });
//   // }

//   var just_stadiums = {};
//   var stadium_names;
//   Future get_stadium_data() async {
//     var temp;
//     await db
//         .child('ipl')
//         .child('stadiums')
//         .once()
//         .then((DataSnapshot snapshot) {
//       stadium_data = snapshot.value;
//       // print(stadium_data.keys);
//       // print('here');
//       temp = stadium_data.keys.toList();
//       cities = List<String>.from(temp);

//       for (var i in cities) {
//         var stds = stadium_data[i].keys;
//         for (var j in stds) {
//           just_stadiums[j] = i;
//         }
//       }
//     });
//     stadium_names = just_stadiums.keys;

//     return temp;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Search Stadium"),
//         ),
//         body: FutureBuilder(
//             future: get_stadium_data(),
//             builder: (context, snapshot) {
//               switch (snapshot.connectionState) {
//                 case ConnectionState.done:
//                   {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text("Enter the stadium name"),
//                         SearchField(
//                           suggestions: List<String>.from(stadium_names),
//                           maxSuggestionsInViewPort: 5,
//                           hasOverlay: false,
//                         ),
//                         Text("Enter the city"),
//                         SearchField(
//                           suggestions: cities,
//                           hint: 'if u dont know the stadium name',
//                           maxSuggestionsInViewPort: 5,
//                           onTap: (x) {
//                             stadium_names = stadium_data[x].keys.toList();
//                             // print(just_stadiums.runtimeType);
//                             if (stadium_names.length == 1) {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => StadiumInfo(
//                                           stadium_data[x][stadium_names[0]],
//                                           stadium_names[0],
//                                           just_stadiums[stadium_names[0]])));
//                             }
//                           },
//                           hasOverlay: false,
//                         ),
//                       ],
//                     );
//                   }
//                 case ConnectionState.active:
//                   {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                 case ConnectionState.waiting:
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 case ConnectionState.none:
//                   {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//               }
//             }));
//   }
// }
