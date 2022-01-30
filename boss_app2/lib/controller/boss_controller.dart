// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:boss_app2/global.dart' as globals;
import 'package:flutter/cupertino.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//create class LoginController  extends ChangeNotifier
class BossController extends ChangeNotifier {
  //create future string login , parameter is String username and password
  Future<Map> ambilLaporan(
      String tanggal, String bulan, String tahun, String filter) async {
    //create string result
    Map<String, dynamic> result;

    try {
      final response = await http.get(
          Uri.parse(
              "${globals.http_to_server}api/ambil_laporan?tanggal=$tanggal&bulan=$bulan&tahun=$tahun&filter=$filter"),
          headers: {
            "Accept": "application/json",
            "authorization":
                "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
            "crossDomain": "true"
          });
      final data = jsonDecode(response.body);
      result = data;
    } catch (e) {
      result = {"status": "error", "message": e.toString()};
    }

    return result;
  }

  Future<Map> ambilLaporanDetail(String no_log) async {
    //create string result
    Map<String, dynamic> result;

    try {
      final response = await http.get(
          Uri.parse(
              "${globals.http_to_server}api/ambil_laporan_detail?no_log=$no_log"),
          headers: {
            "Accept": "application/json",
            "authorization":
                "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
            "crossDomain": "true"
          });

      final data = jsonDecode(response.body);

      result = data;
    } catch (e) {
      result = {"status": "error", "message": e.toString()};
    }

    return result;
  }

  Future<Map> ambilProdukAll(
      int pageNumber, String filter, String cekFilter) async {
    Map<String, dynamic> result;

    try {
      final response = await http.get(
          Uri.parse(
              "${globals.http_to_server}api/ambil_produk_all?page=$pageNumber&filter=$filter&cekfilter=$cekFilter"),
          headers: {
            "Accept": "application/json",
            "authorization":
                "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
            "crossDomain": "true"
          });

      final data = jsonDecode(response.body);

      result = data;
    } catch (e) {
      result = {"status": "error", "message": e.toString()};
    }

    return result;
  }

  Future<Map> ambilLaporanProdukDetail(
      int no_barang, int pageNumber, String filter, String cek_filter) async {
    Map<String, dynamic> result;

    try {
      final response = await http.get(
          Uri.parse(
              "${globals.http_to_server}api/ambil_log_produk_detail?no_barang=$no_barang&page=$pageNumber&haha=$cek_filter&filter=$filter"),
          headers: {
            "Accept": "application/json",
            "authorization":
                "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
            "crossDomain": "true"
          });

      final data = jsonDecode(response.body);
      result = data;
    } catch (e) {
      result = {"status": "error", "message": e.toString()};
    }

    return result;
  }

  Future<Map> ambilProdukDetail(int no_barang) async {
    Map<String, dynamic> result;

    try {
      final response = await http.get(
          Uri.parse(
              "${globals.http_to_server}api/ambil_produk_detail?no_barang=$no_barang"),
          headers: {
            "Accept": "application/json",
            "authorization":
                "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
            "crossDomain": "true"
          });

      final data = jsonDecode(response.body);

      result = data;
    } catch (e) {
      result = {"status": "error", "message": e.toString()};
    }

    return result;
  }

  Future<Map> ambilLaporanAll(
      int pageNumber, String filter, String cek_filter) async {
    Map<String, dynamic> result;

    try {
      final response = await http.get(
          Uri.parse(
              "${globals.http_to_server}api/ambil_laporan_all?page=$pageNumber&haha=$cek_filter&filter=$filter"),
          headers: {
            "Accept": "application/json",
            "authorization":
                "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
            "crossDomain": "true"
          });

      final data = jsonDecode(response.body);
      result = data;
    } catch (e) {
      result = {"status": "error", "message": e.toString()};
    }

    return result;
  }

  Future<void> laporanRead(String no_log) async {
    final sharedPreference = await SharedPreferences.getInstance();

    // sharedPreference.remove('notif');
    try {
      await http.get(
          Uri.parse("${globals.http_to_server}api/laporan_read?no_log=$no_log"),
          headers: {
            "Accept": "application/json",
            "authorization":
                "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
            "crossDomain": "true"
          });

      // final data = jsonDecode(response.body);
      final String? _notif = sharedPreference.getString('notif');
      if (_notif != null) {
        final List<dynamic> _notifList = jsonDecode(_notif);
        _notifList
            .removeWhere((element) => element.toString() == no_log.toString());

        sharedPreference.setString(
            'notif', (_notifList.isNotEmpty) ? jsonEncode(_notifList) : "");
      }
    } catch (e) {
      // result = {"status": "error", "message": e.toString()};
    }
  }

  Future<void> laporanReadAll() async {
    final sharedPreference = await SharedPreferences.getInstance();

    // sharedPreference.remove('notif');
    try {
      await http.get(Uri.parse("${globals.http_to_server}api/laporan_read_all"),
          headers: {
            "Accept": "application/json",
            "authorization":
                "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
            "crossDomain": "true"
          });
      sharedPreference.remove('notif');
    } catch (e) {
      // result = {"status": "error", "message": e.toString()};
    }
  }
}
