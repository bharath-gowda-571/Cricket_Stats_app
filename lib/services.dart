import 'dart:math';

import 'package:http/http.dart' as http;
import 'constants.dart' as Constants;
import 'dart:convert';

getPopNamesFromAPI() async {
  var pop_names = {};
  final response =
      await http.get(Uri.parse(Constants.API_URL + "/pop_player_names"));
  return response;
}

getBatsmanVsBowlerData(batsman, bowler) async {
  final response = await http.get(Uri.parse(
      Constants.API_URL + "/batsman_vs_bowler_data/" + batsman + "/" + bowler));

  return response;
}

getTeamNames() async {
  final response = await http.get(Uri.parse(Constants.API_URL + "/team_names"));
  if (response.statusCode == 200) {
    var res_body = response.body;
    var parsed = jsonDecode(res_body);
    var teams = List<String>.from(parsed);
    return teams;
  } else {
    throw Exception("Something went wrong");
  }
}

getPlayerVsTeamData(player, team, batting_or_bowling) async {
  final response = await http.get(Uri.parse(Constants.API_URL +
      "/player_vs_team/" +
      player +
      "/" +
      batting_or_bowling +
      "/" +
      team));
  print(response);
  if (response.statusCode == 200) {
    var res_body = response.body;
    var parsed = jsonDecode(res_body);
    return parsed;
  } else {
    throw Exception(
        "API responded with status " + response.statusCode.toString());
  }
}

getPlayerPicture(player) async {
  final response = await http
      .get(Uri.parse(Constants.API_URL + "/player_pictures/" + player));
  if (response.statusCode == 200) {
    var res_body = response.body;
    var parsed = jsonDecode(res_body);
    return parsed;
  } else {
    throw Exception(
        "API responded with status " + response.statusCode.toString());
  }
}
