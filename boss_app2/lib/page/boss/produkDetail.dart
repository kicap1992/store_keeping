// ignore_for_file: unnecessary_statements

import 'dart:convert';

import 'package:boss_app2/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/boss_controller.dart';

class ProdukDetail extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final int no_log;
  // ignore: non_constant_identifier_names
  const ProdukDetail({Key? key, required this.no_log}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  late Map<String, dynamic> _dataProduk;
  int _loadingProduk = 0;

  // ignore: avoid_void_async
  void _ambilProdukDetail(BuildContext context, int noBarang) async {
    setState(() {
      _loadingProduk = 0;
    });
    final BossController _toController =
        Provider.of<BossController>(context, listen: false);

    try {
      final Map _data = await _toController.ambilProdukDetail(noBarang);
      setState(() {
        _dataProduk = _data['data'];
        _loadingProduk = 1;
      });
    } catch (e) {
      setState(() {
        _loadingProduk = 2;
      });
    }
  }

  late List<Map<String, dynamic>> _laporanProduk;
  int _loadingLaporan = 0;
  late int _pageNumberLaporan;
  int _pageNumberLaporanIndex = 1;
  String _filterLaporan = "";
  String _cekFilter = "tiada";
  bool _cekLengthData = false;

  // ignore: avoid_void_async
  void _ambilLogLaporan(BuildContext context, int noBarang, int pageNumber,
      String filter, String cekFilter) async {
    setState(() {
      _loadingLaporan = 0;
      _pageNumberLaporanIndex = pageNumber;
      _cekFilter = cekFilter;
      _filterLaporan = filter;
    });
    _laporanProduk = [];
    final BossController _toController =
        Provider.of<BossController>(context, listen: false);

    try {
      final Map _data = await _toController.ambilLaporanProdukDetail(
          noBarang, pageNumber, filter, cekFilter);
      _laporanProduk = (_data['data'] as List)
          .map((dynamic item) => item as Map<String, dynamic>)
          .toList();
      setState(() {
        if (_laporanProduk.isEmpty) {
          _cekLengthData = false;
        } else {
          _cekLengthData = true;
        }
        _laporanProduk = _laporanProduk;
        _loadingLaporan = 1;
        _pageNumberLaporan = (_data['ceil'] / 10).ceil();
      });
    } catch (e) {
      setState(() {
        _loadingLaporan = 2;
      });
    }
  }

  final TextEditingController _inputFilterLaporan = TextEditingController();

  @override
  void initState() {
    _ambilLogLaporan(context, widget.no_log, 1, _filterLaporan, _cekFilter);
    _ambilProdukDetail(context, widget.no_log);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            OurContainer(
              child: (_loadingProduk == 1)
                  ? Center(
                      child: Column(
                        children: [
                          Text('Kode : ${_dataProduk['kode_barang']}'),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text('Nama : ${_dataProduk['nama']}'),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text('Harga Jual : ${_dataProduk['harga_jual']}'),
                          const Divider(
                            color: Colors.black,
                          ),
                          Text('Stok : ${_dataProduk['jumlah']}'),
                        ],
                      ),
                    )
                  : (_loadingProduk == 0)
                      ? const Center(child: CircularProgressIndicator())
                      : (_loadingProduk == 2)
                          ? const Center(
                              child: Text(
                                  'Koneksi Ke Server Bermasalah, Sila Periksa Jaringan Anda'))
                          : Container(),
            ),
            const SizedBox(height: 20),
            OurContainer(
              child: Center(
                child: Column(
                  children: [
                    if (_loadingLaporan == 1)
                      Column(
                        children: [
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
                                    hintText: 'Berdasarkan Waktu / Status',
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 247, 247, 247),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                ),
                                onPressed: () {
                                  if (_inputFilterLaporan.text == '') {
                                    _ambilLogLaporan(context, widget.no_log, 1,
                                        _inputFilterLaporan.text, 'tiada');
                                  } else {
                                    _ambilLogLaporan(context, widget.no_log, 1,
                                        _inputFilterLaporan.text, 'ada');
                                  }
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  // }
                                },
                                child: const Text('Filter'),
                              ),
                            ],
                          ),
                          if (_cekLengthData)
                            SingleChildScrollView(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(
                                      label: Text('No'),
                                    ),
                                    DataColumn(
                                      label: Text('Waktu'),
                                    ),
                                    DataColumn(
                                      label: Text('Status'),
                                    ),
                                    DataColumn(
                                      label: Text('Keterangan'),
                                    ),
                                  ],
                                  rows: _laporanProduk
                                      .map(
                                        (dynamic item) => DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                item['no_log'].toString(),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                item['waktu'].toString(),
                                              ),
                                            ),
                                            DataCell(
                                              (item['status'] !=
                                                      "Penjualan Barang Spesifik")
                                                  ? Text(
                                                      item['status'].toString(),
                                                    )
                                                  : const Text("Penjualan"),
                                            ),
                                            DataCell(IconButton(
                                              icon: const Icon(Icons.article),
                                              color: Colors.blue,
                                              onPressed: () {
                                                _bottomSheetModal(
                                                    context, item);
                                              },
                                            )),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            )
                          else
                            Column(
                              children: [
                                const SizedBox(height: 20),
                                Center(
                                    child: Text(
                                  'Tidak Ada Rekod Laporan Untuk Filter "${_inputFilterLaporan.text}"',
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                        ],
                      )
                    else
                      (_loadingLaporan == 0)
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : (_loadingLaporan == 2)
                              ? const Center(
                                  child: Text(
                                    'Koneksi Ke Serverl Bermasalah, Sila Periksa Jaringan Anda',
                                  ),
                                )
                              : Container(),
                    _pageButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: avoid_void_async
  void _bottomSheetModal(
      BuildContext context, Map<String, dynamic> _result) async {
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

    if (_result['status'] == 'Edit Detail Produk') {
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

  SingleChildScrollView _pageButton() {
    final List<Widget> _pageButton = <Widget>[];

    if (_loadingLaporan == 1) {
      if (_pageNumberLaporan >= 1 && _pageNumberLaporan <= 3) {
        for (int i = 1; i <= _pageNumberLaporan; i++) {
          _pageButton.add(
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: (_pageNumberLaporanIndex == 1 && i == 1)
                    ? Colors.grey
                    : (_pageNumberLaporanIndex == 2 && i == 2)
                        ? Colors.grey
                        : (_pageNumberLaporanIndex == 3 && i == 3)
                            ? Colors.grey
                            : Colors.blue,
              ),
              onPressed: () {
                if (_pageNumberLaporanIndex == 1 && i == 1) {
                } else if (_pageNumberLaporanIndex == 2 && i == 2) {
                } else if (_pageNumberLaporanIndex == 3 && i == 3) {
                } else {
                  setState(() {
                    _pageNumberLaporanIndex = i;
                    // _pageNumberLaporan = i;
                  });
                  _ambilLogLaporan(
                      context, widget.no_log, i, _filterLaporan, _cekFilter);
                }
              },
              child: Text(i.toString()),
            ),
          );
        }
      } else if (_pageNumberLaporan > 3) {
        _pageButton.add(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary:
                  (_pageNumberLaporanIndex != 1) ? Colors.blue : Colors.grey,
            ),
            onPressed: () {
              _ambilLogLaporan(context, widget.no_log,
                  _pageNumberLaporanIndex - 1, _filterLaporan, _cekFilter);
            },
            child: const Text('<'),
          ),
        );
        _pageButton.add(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary:
                  (_pageNumberLaporanIndex != 1) ? Colors.blue : Colors.grey,
            ),
            onPressed: () {
              _ambilLogLaporan(
                  context, widget.no_log, 1, _filterLaporan, _cekFilter);
            },
            child: const Text('1'),
          ),
        );
        _pageButton.add(
          const Text('...'),
        );

        if (_pageNumberLaporanIndex != 1 &&
            _pageNumberLaporanIndex != _pageNumberLaporan) {
          _pageButton.add(
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                primary: Colors.grey,
              ),
              onPressed: () {
                null;
              },
              child: Text(_pageNumberLaporanIndex.toString()),
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
              primary: (_pageNumberLaporanIndex != _pageNumberLaporan)
                  ? Colors.blue
                  : Colors.grey,
            ),
            onPressed: () {
              _ambilLogLaporan(context, widget.no_log, _pageNumberLaporan,
                  _filterLaporan, _cekFilter);
            },
            child: Text(_pageNumberLaporan.toString()),
          ),
        );
        _pageButton.add(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              primary: (_pageNumberLaporanIndex != _pageNumberLaporan)
                  ? Colors.blue
                  : Colors.grey,
            ),
            onPressed: () {
              _ambilLogLaporan(context, widget.no_log,
                  _pageNumberLaporanIndex + 1, _filterLaporan, _cekFilter);
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
}
