// ignore_for_file: unused_element, non_constant_identifier_names
import 'dart:convert';
import 'package:boss_app/controller/boss_controller.dart';
import 'package:boss_app/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

// import '../../controller/datatables_laporan.dart';

class HomeAdmin extends StatefulWidget {
  // const HomeAdmin({Key? key}) : super(key: key);
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  int _year = DateTime.now().year.toInt();
  int _bulan = 0;
  String _hintTextBulanTahun = '-Pilih Bulan / Tahun Terlebih Dahulu';

  //create string tanggal from today
  // ignore: prefer_final_fields
  String _tanggal =
      '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
  // ignore: prefer_final_fields, prefer_interpolation_to_compose_strings
  String _headerLaporan = "Laporan Tanggal " +
      DateTime.now().year.toString() +
      '-' +
      DateTime.now().month.toString() +
      '-' +
      DateTime.now().day.toString();

  //create list map with field waktu, status, dan ket and push 10 random data
  // List<Map<String, String>> _listLaporan = [];

  late List<Map<String, String>> _laporan;
  // late List<Map<String, dynamic>> _laporanDetail;
  int _loadingLaporan = 0;

  // ignore: avoid_void_async
  void _ambilLaporan(String tanggal, String bulan, String tahun, String filter,
      BuildContext context) async {
    // print(context);
    // print('hehe');
    final BossController _ambilLaporan =
        Provider.of<BossController>(context, listen: false);

    setState(() {
      _loadingLaporan = 0;
    });
    // print(_login);
    try {
      final Map _data =
          await _ambilLaporan.ambilLaporan(tanggal, bulan, tahun, filter);
      // Navigator.pop(context);

      // print(_data);
      if (_data['status'] == 'success') {
        //loop the _data['data'] and push to _laporan by field waktu, status, dan ket
        if (_data['data'].length > 0) {
          _laporan = <Map<String, String>>[];
          for (int i = 0; i < _data['data'].length; i++) {
            _laporan.add({
              'waktu': _data['data'][i]['waktu'].toString(),
              'status': _data['data'][i]['status'],
              'ket': _data['data'][i]['ket'].toString(),
              'no_log': _data['data'][i]['no_log'].toString(),
            });
          }
          _laporan = _laporan;
          setState(() {
            _loadingLaporan = 1;
          });
        } else {
          setState(() {
            _loadingLaporan = 2;
          });
        }
      } else if (_data['status'] == 'error') {
        setState(() {
          _loadingLaporan = 3;
        });
      }
    } catch (e) {
      setState(() {
        _loadingLaporan = 3;
      });
    }
  }

  int _loadingBottomSheet = 0;
  // ignore: avoid_void_async
  void _ambilLaporanDetail(String no_log, BuildContext context) async {
    // print('sini no_log' + no_log);
    final BossController _ambilLaporan =
        Provider.of<BossController>(context, listen: false);

    // ignore: prefer_final_locals
    Map<String, dynamic> _result = {'data': 0};

    setState(() {
      _loadingBottomSheet = 0;

      _bottomSheetModal(context, _result);
    });

    try {
      final Map _data = await _ambilLaporan.ambilLaporanDetail(no_log);
      print(_data['status']);
      Navigator.pop(context);
      if (_data['status'] == 'success') {
        // print(_data);

        setState(() {
          _loadingBottomSheet = 1;
          // _laporanDetail = _data['data'][0];
          _bottomSheetModal(context, _data['data'][0]);
        });
      } else if (_data['status'] == 'error') {
        setState(() {
          _loadingBottomSheet = 2;

          _bottomSheetModal(context, _result);
        });
      }
    } catch (e) {
      setState(() {
        _loadingBottomSheet = 2;
        _bottomSheetModal(context, _result);
      });
    }
  }

  Future<dynamic> _bottomSheetModal(
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
            SizedBox(
              height: (_loadingBottomSheet == 0 || _loadingBottomSheet == 2)
                  ? 50
                  : 20,
            ),
            if (_loadingBottomSheet == 0)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_loadingBottomSheet == 1)
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
              )
            else if (_loadingBottomSheet == 2)
              const Text(
                  'Koneksi Ke Server Bermasalah, Sila Periksa Jaringan Anda'),
            if (_loadingBottomSheet == 0 || _loadingBottomSheet == 2)
              const SizedBox(
                height: 50,
              )
            else if (_loadingBottomSheet == 1)
              const SizedBox(
                height: 30,
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailLaporan(Map<String, dynamic> _result) {
    // print(_result);
    FocusManager.instance.primaryFocus?.unfocus();
    final Map<String, dynamic> _ket = jsonDecode(_result['ket']);
    // print(_ket);
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
          Text("Status : ${_result['status']}"),
          const Divider(
            color: Colors.black,
          ),
          _detail,
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // _pushYears();
    // _pushMonths();
    _ambilLaporan(_tanggal, '', '', '', context);
  }

  // final DataTableSource _data = MyData();
  // ignore: prefer_final_fields
  int _currentSortColumn = 0;
  bool _isAscending = true;

  // bool _buttonFilter = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _filterLaporan = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // return Scaffold
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            OurContainer(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Form Pilih Bulan / Tahun Laporan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                      hintText: _hintTextBulanTahun,
                      filled: true,
                      fillColor: const Color.fromARGB(255, 247, 247, 247),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //create elevated button
                  ElevatedButton(
                    child: const Text('Klik Untuk Pilih Bulan / Tanggal'),
                    onPressed: () {
                      showMonthPicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime.now(),
                        initialDate: DateTime.now(),
                        locale: const Locale("id"),
                      ).then((date) {
                        // print(date);
                        // get only month and year on date

                        setState(() {
                          _tanggal = '';
                          _bulan = date!.month;
                          _year = date.year;
                          _hintTextBulanTahun =
                              'Bulan  ${_bulan.toString()} / Tahun  ${_year.toString()}';
                          _headerLaporan =
                              "Laporan Bulan ${_bulan.toString()} /  Tahun ${_year.toString()}";
                        });
                        _ambilLaporan('', _bulan.toString(), _year.toString(),
                            '', context);
                        // _tanggal = date.day.toString();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            OurContainer(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      _headerLaporan,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  //create data table with column "Waktu", "Status", "Aksi" and 10 rows
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _filterLaporan,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              isDense: true,
                              hintText: 'Berdasarkan Waktu / Status',
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 247, 247, 247),
                            ),
                            // onChanged: (value) {
                            //   // print(value);
                            //   if (value.isEmpty) {
                            //     setState(() {
                            //       _buttonFilter = false;
                            //     });
                            //   } else {
                            //     setState(() {
                            //       _buttonFilter = true;
                            //     });
                            //   }
                            // },
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        //disabed the button
                        style:
                            // _buttonFilter
                            //     ?
                            ElevatedButton.styleFrom(
                          primary: Colors.blue,
                        )
                        // : ElevatedButton.styleFrom(
                        //     primary: Colors.grey,
                        //   )
                        ,
                        onPressed: () {
                          // if (_buttonFilter) {
                          // print(_filterLaporan.text);
                          // print(_tanggal + "heheh");
                          // print(_bulan);
                          // print(_year);
                          if (_tanggal == '') {
                            _ambilLaporan('', _bulan.toString(),
                                _year.toString(), _filterLaporan.text, context);
                          } else {
                            _ambilLaporan(
                                _tanggal, '', '', _filterLaporan.text, context);
                          }
                          FocusManager.instance.primaryFocus?.unfocus();
                          // }
                        },
                        child: const Text('Filter'),
                      ),
                    ],
                  ),

                  _tampilkanLaporan()

                  // PaginatedDataTable(
                  //   columns: [
                  //     DataColumn(label: const Text('Waktu')),
                  //     DataColumn(label: const Text('Status')),
                  //     DataColumn(label: const Text('Aksi')),
                  //   ],

                  //   //source from _listLaporan
                  //   source: _data,
                  // )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tampilkanLaporan() {
    //create switch case
    switch (_loadingLaporan) {
      case 0:
        return Column(
          children: const [
            SizedBox(
              height: 30,
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        );
      case 1:
        // ignore: sized_box_for_whitespace
        return Container(
          height: 400,
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: const Text('Waktu'),
                    onSort: (columnIndex, _) {
                      setState(() {
                        if (_isAscending == false) {
                          _laporan.sort((a, b) {
                            return b['waktu']!.compareTo(a['waktu']!);
                          });
                          _isAscending = true;
                        } else {
                          _isAscending = false;
                          _laporan.sort((a, b) {
                            return a['waktu']!.compareTo(b['waktu']!);
                          });
                        }
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text('Status'),
                    onSort: (columnIndex, _) {
                      setState(() {
                        if (_isAscending == false) {
                          _laporan.sort((a, b) {
                            return b['status']!.compareTo(a['status']!);
                          });
                          _isAscending = true;
                        } else {
                          _isAscending = false;
                          _laporan.sort((a, b) {
                            return a['status']!.compareTo(b['status']!);
                          });
                        }
                      });
                    },
                  ),
                  const DataColumn(label: Text('Aksi')),
                ],
                //rows = _laporan
                rows: _laporan
                    .map((Map<String, dynamic> laporan) => DataRow(
                          cells: [
                            DataCell(Text(laporan['waktu']!)),
                            DataCell(Text(laporan['status']!)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.article),
                                    color: Colors.blue,
                                    onPressed: () {
                                      _ambilLaporanDetail(
                                          laporan['no_log']!.toString(),
                                          context);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ))
                    .toList(),
                sortColumnIndex: _currentSortColumn,
                sortAscending: _isAscending,
              ),
            ),
          ),
        );

      case 2:
        return Column(
          children: const [
            SizedBox(
              height: 20,
            ),
            Align(
              child: Text('Tidak ada laporan untuk filter ini'),
            ),
          ],
        );

      case 3:
        return Column(
          children: const [
            SizedBox(
              height: 20,
            ),
            Align(
              child: Text(
                  'Koneksi ke server gagal, Sila Cek Koneksi Internet Anda'),
            ),
          ],
        );

      default:
        return Container();
    }
  }
}
