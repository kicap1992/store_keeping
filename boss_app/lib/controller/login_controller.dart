import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//create class LoginController  extends ChangeNotifier
class LoginController extends ChangeNotifier {
  //create future string login , parameter is String username and password
  Future<String> login(String username, String password) async {
    late String _returnString;
    // print("sini dia");

    try {
      //create final sharedPreferences
      final sharedPreferences = await SharedPreferences.getInstance();

      //create http get wih basic auth
      final response = await http.get(
          Uri.parse(
              "http://192.168.43.125/ilham/server2/api/login_user?username=$username&password=$password"),
          headers: {
            "Accept": "application/json",
            "authorization":
                "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
            "crossDomain": "true"
          });
      final data = jsonDecode(response.body);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        if (data['data']['level'] == '0') {
          sharedPreferences.setString('level', 'Superadmin');
        } else if (data['data']['level'] == '1') {
          sharedPreferences.setString('level', 'Boss');
        }
        _returnString = "1";
        sharedPreferences.setString('data', jsonEncode(data['data']));
      } else if (response.statusCode == 401) {
        _returnString = "2";
      }
    } catch (e) {
      // print(e);
      _returnString = "3";
    }

    //return result
    return _returnString;
  }

  // Future<Map> login(String username, String password) async {
  //   //create string result
  //   // String result = "try";
  //   //create map data
  //   Map datanya;
  //   //create http get wih basic auth
  //   var response = await http.get(
  //       Uri.parse(
  //           "http://192.168.43.125/ilham/server2/api/login_user?username=$username&password=$password"),
  //       headers: {
  //         "Accept": "application/json",
  //         "authorization": "Basic " +
  //             base64Encode(
  //                 utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73")),
  //         "crossDomain": "true"
  //       });
  //   final data = jsonDecode(response.body);
  //   // print(data["message"][0]['username']);
  //   datanya = data;
  //   print(response.statusCode);
  //   // switch (response.statusCode) {
  //   //   case 200:
  //   //     final data = response.body;
  //   //     print(data);
  //   //     break;
  //   //   default:
  //   // }

  //return result
  //   return datanya;
  // }

}
