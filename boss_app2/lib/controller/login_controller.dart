import 'dart:convert';

import 'package:boss_app2/global.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//create class LoginController  extends ChangeNotifier
class LoginController extends ChangeNotifier {
  //create future string login , parameter is String username and password
  Future<String> login(String username, String password) async {
    late String _returnString;

    try {
      //create final sharedPreferences
      final sharedPreferences = await SharedPreferences.getInstance();

      //create http get wih basic auth
      final response = await http.get(
          Uri.parse(
              "${globals.http_to_server}api/login_user?username=$username&password=$password"),
          headers: {
            "Accept": "application/json",
            "authorization":
                "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
            "crossDomain": "true"
          });
      final data = jsonDecode(response.body);
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
      _returnString = "3";
    }

    //return result
    return _returnString;
  }

  Future<int> getNotif() async {
    int result;
    final sharedPreferences = await SharedPreferences.getInstance();
    try {
      final response = await http
          .get(Uri.parse("${globals.http_to_server}api/cek_datanya"), headers: {
        "Accept": "application/json",
        "authorization":
            "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
        "crossDomain": "true"
      });
      final data = jsonDecode(response.body);
      final List datanya = data['data'];

      final String? _notif = sharedPreferences.getString('notif');
      List<dynamic> _arrayNotif;
      if (_notif == null) {
        _arrayNotif = [];
      } else {
        _arrayNotif = jsonDecode(_notif);
      }

      int jumlah = datanya.length;
      bool cek = false;

      for (var i = 0; i < datanya.length; i++) {
        cek = false;
        for (var j = 0; j < _arrayNotif.length; j++) {
          if (_arrayNotif[j].toString() == datanya[i]['no_log'].toString()) {
            jumlah = jumlah - 1;
            cek = true;
            break;
          }
        }

        if (cek == false) {
          _arrayNotif.add(int.parse(datanya[i]['no_log']));
        }
        cek = false;
      }

      sharedPreferences.setString('notif', jsonEncode(_arrayNotif));
      // // if (jumlah > 0) {
      // //   NotificationApi.showNotification(
      // //     title: 'Laporan Baru',
      // //     body: 'Ada $jumlah laporan baru',
      // //     payload: 'Laporan Baru',
      // //   );
      // // }

      result = jumlah;
      // result = datanya;
    } catch (e) {
      // result = [];
      result = 0;
    }

    return result;
  }
}
