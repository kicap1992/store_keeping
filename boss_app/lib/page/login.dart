// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:boss_app/controller/login_controller.dart';
import 'package:boss_app/page/before_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

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
      print(_returnString);

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
      print(e);
    }

    // print(_login);
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
  }

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
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
