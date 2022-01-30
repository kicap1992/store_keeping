import 'dart:convert';

import 'package:boss_app2/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controller/boss_controller.dart';

class LaporanPenuh extends StatefulWidget {
  const LaporanPenuh({Key? key}) : super(key: key);

  @override
  _LaporanPenuhState createState() => _LaporanPenuhState();
}

class _LaporanPenuhState extends State<LaporanPenuh> {
  late List<Map<String, dynamic>> _laporanAll;
  int _loadingLaporanAll = 0;
  late int _pageNumber;
  int _pageNumberIndex = 1;
  String _cekFilter = 'tiada';
  String _filterLaporan = '';
  final _inputFilterLaporan = TextEditingController();

  // ignore: avoid_void_async
  void _ambilLaporanAll(BuildContext context, int pageNumber, String filter,
      String cekFilter) async {
    setState(() {
      _loadingLaporanAll = 0;
      _pageNumberIndex = pageNumber;
      _cekFilter = cekFilter;
      _filterLaporan = filter;
    });
    _laporanAll = [];
    final BossController _toController =
        Provider.of<BossController>(context, listen: false);

    try {
      final Map _data =
          await _toController.ambilLaporanAll(pageNumber, filter, cekFilter);

      if (_data['status'] == 'success') {
        //loop the _data['data'] and push to _laporan by field waktu, status, dan ket
        if (_data['data'].length > 0) {
          _laporanAll = (_data['data'] as List)
              .map((dynamic item) => item as Map<String, dynamic>)
              .toList();
          setState(() {
            _loadingLaporanAll = 1;
            _pageNumber = (_data['ceil'] / 10).ceil();
          });
        } else {
          setState(() {
            _loadingLaporanAll = 2;
          });
        }
      } else if (_data['status'] == 'error') {
        setState(() {
          _loadingLaporanAll = 3;
        });
      }
    } catch (e) {
      setState(() {
        _loadingLaporanAll = 3;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _ambilLaporanAll(context, _pageNumberIndex, _filterLaporan, _cekFilter);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            OurContainer(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Filter Laporan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _inputFilterLaporan,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            isDense: true,
                            hintText: 'Kode / Nama Produk',
                            filled: true,
                            fillColor: const Color.fromARGB(255, 247, 247, 247),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_inputFilterLaporan.text == '') {
                            _ambilLaporanAll(
                                context, 1, _filterLaporan, 'tiada');
                          } else {
                            _ambilLaporanAll(
                                context, 1, _inputFilterLaporan.text, 'ada');
                          }
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: const Text('Filter'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            OurContainer(
                child: (_loadingLaporanAll == 0)
                    ? Column(
                        children: const [
                          SizedBox(height: 25),
                          Center(child: CircularProgressIndicator())
                        ],
                      )
                    : (_loadingLaporanAll == 2)
                        ? Column(
                            children: const [
                              SizedBox(height: 25),
                              Center(
                                child: Text(
                                    'Koneksi Ke Server Bermasalah, Sila Periksa Jaringan Anda'),
                              )
                            ],
                          )
                        : (_loadingLaporanAll == 1)
                            ? Column(
                                children: [
                                  Container(
                                    constraints: const BoxConstraints(
                                      maxHeight: 450,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: DataTable(
                                              columns: const [
                                                DataColumn(label: Text('No')),
                                                DataColumn(
                                                    label: Text('Waktu')),
                                                DataColumn(
                                                    label: Text('Status')),
                                                DataColumn(
                                                    label: Text('Keterangan')),
                                              ],
                                              rows: _laporanAll.map(
                                                  (Map<String, dynamic> item) {
                                                return DataRow(
                                                  cells: [
                                                    // DataCell(Text('${_laporanAll.indexOf(item) + 1}')),
                                                    DataCell(Text(
                                                        '${item['no_log']}')),
                                                    DataCell(Text(
                                                        '${item['waktu']}')),
                                                    DataCell(Text(
                                                        '${item['status']}')),
                                                    DataCell(IconButton(
                                                      icon: const Icon(
                                                          Icons.article),
                                                      color: Colors.blue,
                                                      onPressed: () {
                                                        _bottomSheetModal(
                                                            context, item);
                                                      },
                                                    )),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  _pageButton(context),
                                ],
                              )
                            : const SizedBox()),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              // title: const Text('Yakin?'),
              content: const Text(
                'Ubah Seluruh Laporan Menjadi Sudah Dibaca?',
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final BossController _provider =
                          Provider.of<BossController>(context, listen: false);

                      try {
                        await _provider.laporanReadAll();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Semua Laporan Diubah Menjadi Terbaca"),
                        ));
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "Koneksi Ke Server Bermasalah, Sila Periksa Jaringan Anda"),
                        ));
                      }
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: const Text(
                      'Ya',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.sticky_note_2_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }

  SingleChildScrollView _pageButton(BuildContext context) {
    final List<Widget> _pageButton = <Widget>[];

    if (_loadingLaporanAll == 1) {
      if (_pageNumber >= 1 && _pageNumber <= 3) {
        for (int i = 1; i <= _pageNumber; i++) {
          _pageButton.add(
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: (_pageNumberIndex == 1 && i == 1)
                    ? Colors.grey
                    : (_pageNumberIndex == 2 && i == 2)
                        ? Colors.grey
                        : (_pageNumberIndex == 3 && i == 3)
                            ? Colors.grey
                            : Colors.blue,
              ),
              onPressed: () {
                if (_pageNumberIndex == 1 && i == 1) {
                } else if (_pageNumberIndex == 2 && i == 2) {
                } else if (_pageNumberIndex == 3 && i == 3) {
                } else {
                  setState(() {
                    _pageNumberIndex = i;
                    // _pageNumber = i;
                  });
                  _ambilLaporanAll(context, i, _filterLaporan, _cekFilter);
                }
              },
              child: Text(i.toString()),
            ),
          );
        }
      } else if (_pageNumber > 3) {
        _pageButton.add(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: (_pageNumberIndex != 1) ? Colors.blue : Colors.grey,
            ),
            onPressed: () {
              _ambilLaporanAll(
                  context, _pageNumberIndex - 1, _filterLaporan, _cekFilter);
            },
            child: const Text('<'),
          ),
        );
        _pageButton.add(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: (_pageNumberIndex != 1) ? Colors.blue : Colors.grey,
            ),
            onPressed: () {
              _ambilLaporanAll(context, 1, _filterLaporan, _cekFilter);
            },
            child: const Text('1'),
          ),
        );
        _pageButton.add(
          const Text('...'),
        );

        if (_pageNumberIndex != 1 && _pageNumberIndex != _pageNumber) {
          _pageButton.add(
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: Colors.grey,
              ),
              onPressed: () {},
              child: Text(_pageNumberIndex.toString()),
            ),
          );
          _pageButton.add(
            const Text('...'),
          );
        }

        _pageButton.add(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary:
                  (_pageNumberIndex != _pageNumber) ? Colors.blue : Colors.grey,
            ),
            onPressed: () {
              _ambilLaporanAll(
                  context, _pageNumber, _filterLaporan, _cekFilter);
            },
            child: Text(_pageNumber.toString()),
          ),
        );
        _pageButton.add(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary:
                  (_pageNumberIndex != _pageNumber) ? Colors.blue : Colors.grey,
            ),
            onPressed: () {
              _ambilLaporanAll(
                  context, _pageNumberIndex + 1, _filterLaporan, _cekFilter);
            },
            child: const Text('>'),
          ),
        );
      }
    } else {
      _pageButton.add(const SizedBox());
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _pageButton,
      ),
    );
  }

  // ignore: avoid_void_async
  void _bottomSheetModal(
      BuildContext context, Map<String, dynamic> _result) async {
    final BossController _provider =
        Provider.of<BossController>(context, listen: false);

    try {
      await _provider.laporanRead(_result['no_log'].toString());
    } catch (e) {
      // print(e);
    }

    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width -
                                (MediaQuery.of(context).size.width * 0.8)) /
                            2,
                      ),
                      const Text(
                        'Detail Laporan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _detailLaporan(_result),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailLaporan(Map<String, dynamic> _result) {
    FocusManager.instance.primaryFocus?.unfocus();
    final Map<String, dynamic> _ket = jsonDecode(_result['ket']);
    // ignore: prefer_typing_uninitialized_variables
    var _detail;
    final formatter = NumberFormat('#,000');

    if (_result['status'] == 'Penjualan Produk') {
      //create var list map
      final List<Map<String, dynamic>> _arrayPenjualan = (_ket['ket'] as List)
          .map((dynamic item) => item as Map<String, dynamic>)
          .toList();

      final _widgetTabel = DataTable(
        columns: const [
          DataColumn(
            label: Text('Kode Barang'),
          ),
          DataColumn(
            label: Text('Jumlah'),
          ),
          DataColumn(
            label: Text('Harga Jual'),
          ),
          DataColumn(
            label: Text('Total'),
          ),
          DataColumn(
            label: Text('Stok Sebelumnya'),
          ),
          DataColumn(
            label: Text('Stok Terkini'),
          ),
        ],
        rows: _arrayPenjualan
            .map((Map<String, dynamic> laporan) => DataRow(
                  cells: [
                    DataCell(Text(laporan['kode_barang']!)),
                    DataCell(Text(laporan['jumlah']!.toString())),
                    DataCell(Text("Rp. ${laporan['harga_jual']!}")),
                    DataCell(Text("Rp. ${formatter.format(laporan['total'])}")),
                    DataCell(
                        Text(laporan['jumlah_stok_sebelumnya']!.toString())),
                    DataCell(Text(laporan['jumlah_stok_sekarang']!.toString())),
                  ],
                ))
            .toList(),
      );

      _detail = Column(
        children: [
          Text("Total Belanja : Rp. ${_ket['total_belanja']}"),
          const Divider(
            color: Colors.black,
          ),
          Text("Pembayaran : Rp. ${_ket['pembayaran']}"),
          const Divider(
            color: Colors.black,
          ),
          Text("Kembalian : Rp. ${_ket['baki']}"),
          const Divider(
            color: Colors.black,
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: _widgetTabel),
          ),
        ],
      );
    } else if (_result['status'] == 'Edit Detail Produk') {
      // ignore: prefer_typing_uninitialized_variables
      var _namanya, _harganya, _fotonya;
      if (_ket['nama_lama'] != _ket['nama_baru']) {
        _namanya = Column(
          children: [
            Text('Nama  : ${_ket['nama_lama']} => ${_ket['nama_baru']}'),
            const Divider(
              color: Colors.black,
            ),
          ],
        );
      } else {
        _namanya = const SizedBox();
      }

      if (_ket['harga_lama'] != _ket['harga_baru']) {
        _harganya = Column(
          children: [
            Text(
                'Harga  : Rp. ${_ket['harga_lama']} => Rp. ${_ket['harga_baru']}'),
            const Divider(
              color: Colors.black,
            ),
          ],
        );
      } else {
        _harganya = const SizedBox();
      }

      if (_ket['foto_lama'] != _ket['foto_baru']) {
        _fotonya = Text('Foto  : ${_ket['foto_lama']} => ${_ket['foto_baru']}');
      } else {
        _fotonya = const SizedBox();
      }

      _detail = Column(
        children: [
          _namanya,
          _harganya,
          _fotonya,
        ],
      );
    } else if (_result['status'] == 'Penambahan Stok') {
      _detail = Column(
        children: [
          Text("Penambahan Stok : ${_ket['penambahan_stok']}"),
          const Divider(
            color: Colors.black,
          ),
          Text("Harga Pembelian : Rp. ${_ket['harga_pembelian_stok']}"),
          const Divider(
            color: Colors.black,
          ),
          Text("Stok Sebelumnya : ${_ket['jumlah_stok_sebelumnya']}"),
          const Divider(
            color: Colors.black,
          ),
          Text("Stok Baru : ${_ket['total_stok']}"),
          const Divider(
            color: Colors.black,
          ),
        ],
      );
    } else if (_result['status'] == 'Penambahan Produk Baru') {
      _detail = Column(
        children: [
          Text("Kode Barang : ${_ket['kode_barang']}"),
          const Divider(
            color: Colors.black,
          ),
          Text("Nama Barang : ${_ket['nama']}"),
          const Divider(
            color: Colors.black,
          ),
          Text("Harga Jual : Rp. ${_ket['harga_jual']}"),
          const Divider(
            color: Colors.black,
          ),
          Text("Harga Pembelian Stok : Rp. ${_ket['pembelian_stok']}"),
          const Divider(
            color: Colors.black,
          ),
          Text("Jumlah : ${_ket['jumlah']}"),
          const Divider(
            color: Colors.black,
          ),
        ],
      );
    } else if (_result['status'] == 'Penjualan Barang Spesifik') {
      _detail = Column(
        children: [
          Text("Jumlah Pembelian : ${_ket['jumlah_pembelian']}"),
          const Divider(
            color: Colors.black,
          ),
          Text("Harga Jual : Rp. ${_ket['harga_jual']}"),
          const Divider(
            color: Colors.black,
          ),
          Text("Stok Sebelumnya : ${_ket['stok_sebelumnya']}"),
          const Divider(
            color: Colors.black,
          ),
          Text("Stok Terbaru : ${_ket['stok_sekarang']}"),
          const Divider(
            color: Colors.black,
          ),
        ],
      );
    } else {
      _detail = Container();
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(
                4,
                4,
              ),
            ),
          ]),
      child: Column(
        children: [
          Text("Waktu : ${_result['waktu']}"),
          const Divider(
            color: Colors.black,
          ),
          Text(
              "Status : ${(_result['status'] == 'Penjualan Barang Spesifik') ? 'Penjualan' : _result['status'].toString()}"),
          const Divider(
            color: Colors.black,
          ),
          _detail,
        ],
      ),
    );
  }
}
