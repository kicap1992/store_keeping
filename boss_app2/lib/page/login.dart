// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'dart:async';

import 'package:boss_app2/controller/login_controller.dart';
import 'package:boss_app2/controller/notification_api.dart';
import 'package:boss_app2/page/before_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  // ignore: avoid_unused_constructor_parameters, prefer_const_constructors_in_immutables
  Login({Key? key, String? payload}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  //create shared prefs
  late SharedPreferences sharedPreferences;
  //create 2 final variables , one for the username and one for the password = TextEditingController
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  late FocusNode myFocusNode;

  //create void _login with 3 parameters, username, password and context
  // ignore: avoid_void_async
  void _login(String username, String password, BuildContext context) async {
    // create final LoginController loginController = provider.of<LoginController>(context, listen: false);
    final LoginController _login =
        Provider.of<LoginController>(context, listen: false);

    //create try catch
    try {
      // final Map _returnString = await _login.login(username, password);
      final String _returnString = await _login.login(username, password);

      //create switch case
      switch (_returnString) {
        case "1":
          showDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(const Duration(milliseconds: 2500), () {
                // Navigator.of(context).pop(true);
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => ScanQRCode(),
                //     ),
                //     (route) => false);
              });
              return const AlertDialog(
                title: Text(
                  "Sukses",
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  "Selamat Login Kembali",
                  textAlign: TextAlign.center,
                ),
              );
            },
          );

          Future.delayed(const Duration(seconds: 3), () {
            // Navigator.of(context).pop(true);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => BeforeLogin(),
                ),
                (route) => false);
          });

          break;

        case "2":
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Username Dan Password Salah"),
          ));
          //focus node
          myFocusNode.requestFocus();
          break;

        case "3":
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
                "Error Koneksi Ke Server, Sila Periksa Jaringan Anda"),
          ));

          break;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            const Text("Error Koneksi Ke Server, Sila Periksa Jaringan Anda"),
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ignore: avoid_void_async, unused_element
  // void _notification() async {
  //   final LoginController _login =
  //       Provider.of<LoginController>(context, listen: false);

  //   //create try catch
  //   try {
  //     // final Map _returnString = await _login.login(username, password);
  //     final List _returnString = await _login.getNotif();
  //     List ini = [1, 2, 3, 4, 5];
  //     bool cek = false;
  //     int jumlah = _returnString.length;
  //     List notif = [];
  //     for (var i = 0; i < _returnString.length; i++) {
  //       cek = false;
  //       for (var j = 0; j < ini.length; j++) {
  //         if (ini[j].toString() == _returnString[i]['no_log'].toString()) {
  //           cek = true;
  //           jumlah = jumlah - 1;
  //           break;
  //         }
  //       }

  //       if (cek == false) {
  //         notif.add(int.parse(_returnString[i]['no_log']));
  //       }
  //       // cek = false;
  //     }
  //   } catch (e) {
  //   }
  //   // NotificationApi.showNotification(
  //   //   title: 'Notification Title',
  //   //   body: 'Notification Body',
  //   //   payload: 'Notification Payload',
  //   // );
  // }

  Stream<int> _getnotif(BuildContext context) async* {
    // List<int> _list = [];
    final LoginController _login =
        Provider.of<LoginController>(context, listen: false);

    while (true) {
      final int _data = await _login.getNotif();
      await Future.delayed(Duration(seconds: 60));
      yield _data;
    }
  }

  // late Timer timer;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();

    // var initializationSettingsAndroid =
    //     AndroidInitializationSettings('flutter_devs');
    // var initializationSettingsIOs = IOSInitializationSettings();
    // var initSetttings = InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    // flutterLocalNotificationsPlugin.initialize(initSetttings,
    //     onSelectNotification: onSelectNotification);
    NotificationApi.init(initScheduled: true, context: context);

    // listenNotifications();
    NotificationApi.showScheduleNotification();
    // _notification();
    // timer = Timer.periodic(Duration(seconds: 10), (Timer t) => _notification());
    _getnotif(context).listen((data) async {
      if (data > 0) {
        NotificationApi.showNotification(
          title: 'Laporan Baru',
          body: 'Ada $data laporan baru',
          payload: 'Laporan Baru',
        );
      }
    });
  }

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
    myFocusNode.dispose();
  }

  // @override
  // // ignore: avoid_void_async
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   sharedPreferences.remove('notif');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //create appbar
      appBar: AppBar(
        title: const Text('Halaman Login'),
      ),
      //create body
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: avoid_redundant_argument_values
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // StreamBuilder(),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            focusNode: myFocusNode,
                            controller: _usernameController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Masukkan Username",
                              labelText: 'Username',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Masukkan Username';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Masukkan Password",
                              labelText: 'Password',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Masukkan Pasword';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          child: ElevatedButton(
                            child: const Text('Login'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                _login(_usernameController.text,
                                    _passwordController.text, context);
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     NotificationApi.showNotification(
                        //       title: 'Notification Title',
                        //       body: 'Notification Body',
                        //       payload: 'Notification Payload',
                        //     );
                        //     // _notification();
                        //     // sharedPreferences.re
                        //   },
                        //   child: Text('sini'),
                        // ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     // _notification();
                        //     NotificationApi.showScheduleNotification();
                        //   },
                        //   child: Text('sini 2'),
                        // ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // void listenNotifications() =>
  //     NotificationApi.onNotifications.stream.listen(onClickedNotification);

  // void onClickedNotification(String? payload) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => Login(payload: payload),
  //     ),
  //   );
  // }
  // Future onSelectNotification(String payload) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
  //     return NewScreen(Login);
  //   }));

  //   throw
  // }
}
