import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

dataStorage(String httpAddress, String dataStorageName) async {
  var response = await http.get(Uri.parse(httpAddress));
  String prefsDatabase;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(response.statusCode == 200) {
    prefsDatabase = response.body;
    prefs.setString(dataStorageName, prefsDatabase);
  } else {
    prefs.getString(dataStorageName);
  }
  //setState(() {});
  return prefs;
}