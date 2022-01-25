// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/cupertino.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;

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
              "http://192.168.43.125/ilham/server2/api/ambil_laporan?tanggal=$tanggal&bulan=$bulan&tahun=$tahun&filter=$filter"),
          headers: {
            "Accept": "application/json",
            "authorization":
                "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
            "crossDomain": "true"
          });
      final data = jsonDecode(response.body);
      result = data;
      // print(result);
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
              "http://192.168.43.125/ilham/server2/api/ambil_laporan_detail?no_log=$no_log"),
          headers: {
            "Accept": "application/json",
            "authorization":
                "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
            "crossDomain": "true"
          });

      final data = jsonDecode(response.body);
      // print(data);
      result = data;
    } catch (e) {
      result = {"status": "error", "message": e.toString()};
    }

    return result;
  }

  Future<Map> ambilProdukAll(int pageNumber, String filter) async {
    Map<String, dynamic> result;

    try {
      final response = await http.get(
          Uri.parse(
              "http://192.168.43.125/ilham/server2/api/ambil_produk_all?page=$pageNumber&filter=$filter"),
          headers: {
            "Accept": "application/json",
            "authorization":
                "Basic ${base64Encode(utf8.encode("Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73"))}",
            "crossDomain": "true"
          });

      final data = jsonDecode(response.body);
      // print(data['data2']);
      result = data;
    } catch (e) {
      result = {"status": "error", "message": e.toString()};
    }

    return result;
  }
}
