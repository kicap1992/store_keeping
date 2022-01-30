import 'package:flutter/material.dart';

class SuperadminIndex extends StatefulWidget {
  const SuperadminIndex({Key? key}) : super(key: key);

  @override
  _SuperadminIndexState createState() => _SuperadminIndexState();
}

class _SuperadminIndexState extends State<SuperadminIndex> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('Superadmin'),
      ),
      body: const Center(
        child: Text('Superadmin'),
      ),
    );
  }
}
