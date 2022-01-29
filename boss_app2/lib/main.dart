import 'package:boss_app2/controller/login_controller.dart';
// import 'package:boss_app/controller/notification_api.dart';
import 'package:boss_app2/page/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'controller/boss_controller.dart';

Future<void> main() async {
  tz.initializeTimeZones();
  // final locationName = await FlutterNativeTimezone.getLocalTimezone();
  // tz.setLocalLocation(tz.getLocation(locationName));
  // tz.initializeTimeZones();
  // WidgetsFlutterBinding.ensureInitialized();
  // NotificationApi().initNotification();
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
        home: Login(),
        // home: const notif,
      ),
    );
  }
}
