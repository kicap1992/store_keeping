import 'package:boss_app/page/boss/homeAdmin.dart';
import 'package:boss_app/page/boss/produk.dart';
import 'package:flutter/material.dart';

class BossIndex extends StatefulWidget {
  @override
  _BossIndexState createState() => _BossIndexState();
}

class _BossIndexState extends State<BossIndex> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Yakin?'),
            content: const Text('Anda Akan Keluar Dari Aplikasi'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: const Text('Ya'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold
    return WillPopScope(
      onWillPop: _onWillPop,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: AppBar().preferredSize.height + 8,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  TabBar(tabs: [
                    Tab(
                      text: 'Home',
                      icon: Icon(Icons.home),
                    ),
                    Tab(
                      text: 'Log Produk',
                      icon: Icon(Icons.home),
                    ),
                    Tab(
                      text: 'Laporan Penuh',
                      icon: Icon(Icons.home),
                    ),
                  ])
                ],
              ),
            ),
            body: TabBarView(
              children: [
                HomeAdmin(),
                ProdukAdmin(),
                Center(
                  child: Text('ini Ketiga'),
                ),
              ],
            )),
      ),
    );
  }
}
