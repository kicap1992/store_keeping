import 'package:boss_app/controller/login_controller.dart';
import 'package:boss_app/page/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/boss_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginController>(
            create: (BuildContext context) => LoginController()),
        ChangeNotifierProvider<BossController>(
            create: (BuildContext context) => BossController()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Login(),
      ),
    );
  }
}
