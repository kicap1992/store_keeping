// ignore_for_file: avoid_void_async

// import 'package:boss_app/page/boss/index.dart';
// import 'package:boss_app/page/login.dart';
// import 'package:boss_app/page/superadmin/index.dart';
import 'package:boss_app2/page/boss/index.dart';
import 'package:boss_app2/page/login.dart';
import 'package:boss_app2/page/superadmin/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeforeLogin extends StatefulWidget {
  const BeforeLogin({Key? key}) : super(key: key);

  @override
  _BeforeLoginState createState() => _BeforeLoginState();
}

class _BeforeLoginState extends State<BeforeLogin> {
  //shared prefs
  late SharedPreferences sharedPreferences;
  int _loading = 0;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    sharedPreferences = await SharedPreferences.getInstance();
    final level = sharedPreferences.getString('level');

    if (level == null) {
      sharedPreferences.remove('level');
      sharedPreferences.remove('data');
      setState(() {
        _loading = 3;
      });
    }
    if (level == 'Superadmin') {
      setState(() {
        _loading = 1;
      });
    }
    if (level == 'Boss') {
      setState(() {
        _loading = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    late Widget retVal;
    switch (_loading) {
      case 0:
        retVal = Scaffold(
          appBar: AppBar(
            title: const Text("Loading"),
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
        break;
      case 1:
        retVal = const SuperadminIndex();
        break;
      case 2:
        retVal = BossIndex();
        break;
      case 3:
        retVal = Login();
        break;
    }

    return retVal;
  }
}
