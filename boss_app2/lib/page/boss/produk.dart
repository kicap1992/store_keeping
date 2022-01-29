import 'package:boss_app2/controller/boss_controller.dart';
import 'package:boss_app2/global.dart' as globals;
import 'package:boss_app2/page/boss/produkDetail.dart';
import 'package:boss_app2/widgets/ourContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProdukAdmin extends StatefulWidget {
  // const ProdukAdmin({Key? key}) : super(key: key);
  @override
  _ProdukAdminState createState() => _ProdukAdminState();
}

class _ProdukAdminState extends State<ProdukAdmin> {
  late List<Map<String, dynamic>> _produkAll;
  int _loadingProdukAll = 0;
  late int _pageNumber;
  int _pageNumberIndex = 1;
  String _cekFilter = 'tiada';

  // ignore: avoid_void_async
  void _ambilProdukAll(BuildContext context, int pageNumber, String filter,
      String cekFilter) async {
    setState(() {
      _loadingProdukAll = 0;
      _pageNumberIndex = pageNumber;
      _cekFilter = cekFilter;
    });
    _produkAll = [];
    final BossController _toController =
        Provider.of<BossController>(context, listen: false);

    try {
      final Map _data =
          await _toController.ambilProdukAll(pageNumber, filter, cekFilter);

      if (_data['status'] == 'success') {
        //loop the _data['data'] and push to _laporan by field waktu, status, dan ket
        if (_data['data'].length > 0) {
          _produkAll = (_data['data'] as List)
              .map((dynamic item) => item as Map<String, dynamic>)
              .toList();
          setState(() {
            _loadingProdukAll = 1;
            _pageNumber = (_data['ceil'] / 10).ceil();
          });
        } else {
          setState(() {
            _loadingProdukAll = 2;
          });
        }
      } else if (_data['status'] == 'error') {
        setState(() {
          _loadingProdukAll = 3;
        });
      }
    } catch (e) {
      setState(() {
        _loadingProdukAll = 3;
      });
    }
  }

  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
    _ambilProdukAll(context, 1, '', _cekFilter);

    super.initState();
  }

  final TextEditingController _filterProduk = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            OurContainer(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Filter Produk",
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
                          controller: _filterProduk,
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
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_filterProduk.text == '') {
                            _ambilProdukAll(context, 1, '', 'tiada');
                          } else {
                            _ambilProdukAll(
                                context, 1, _filterProduk.text, 'ada');
                          }
                        },
                        child: const Text('Cari'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_loadingProdukAll == 0)
                    const Center(child: CircularProgressIndicator())
                  else if (_loadingProdukAll == 1)
                    SizedBox(
                      height: 400,
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              DataTable(
                                columns: const [
                                  DataColumn(
                                    label: Text('Kode'),
                                  ),
                                  DataColumn(
                                    label: Text('Nama'),
                                  ),
                                  DataColumn(
                                    label: Text('Harga'),
                                  ),
                                  DataColumn(
                                    label: Text('Stok'),
                                  ),
                                  DataColumn(
                                    label: Text('Laporan'),
                                  ),
                                ],
                                rows: _produkAll
                                    .map((Map<String, dynamic> item) => DataRow(
                                          cells: [
                                            DataCell(
                                              Row(
                                                children: [
                                                  Text(item['kode_barang']
                                                      .toString()),
                                                  const SizedBox(width: 10),
                                                  GestureDetector(
                                                    onTap: () => _tampilkanFoto(
                                                        context,
                                                        item['no_barang'],
                                                        item['foto']),
                                                    child: Hero(
                                                      tag:
                                                          "image${item['no_barang']}",
                                                      child: CircleAvatar(
                                                        radius: 15,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          "${globals.http_to_server}img/${item['no_barang']}/${item['foto']}",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            DataCell(
                                              Text(item['nama'].toString()),
                                            ),
                                            DataCell(
                                              Text("Rp. ${item['harga_jual']}"),
                                            ),
                                            DataCell(
                                              Text(item['jumlah'].toString()),
                                            ),
                                            DataCell(IconButton(
                                              icon: const Icon(Icons.article),
                                              color: Colors.blue,
                                              onPressed: () {
                                                // _ambilLaporanProduk(
                                                //     context,
                                                //     int.parse(
                                                //         item['no_barang']),
                                                //     1,
                                                //     item);

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProdukDetail(
                                                        no_log: int.parse(
                                                            item['no_barang']),
                                                      ),
                                                    ));
                                              },
                                            )),
                                          ],
                                        ))
                                    .toList(),
                              ),
                              _pageButton(),
                            ],
                          ),
                        ),
                      ),
                    )
                  else if (_loadingProdukAll == 2)
                    const Text(
                      'Tidak ada data',
                      textAlign: TextAlign.center,
                    )
                  else if (_loadingProdukAll == 3)
                    const Text(
                      'Koneksi Ke Server Bermasalah, Sila Periksa Jaringan Anda',
                      textAlign: TextAlign.center,
                    )
                ],
              ),
            ),
            const SizedBox(height: 20),
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

  Future<dynamic> _tampilkanFoto(
      BuildContext context, String item, String foto) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) => SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'image$item',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  "${globals.http_to_server}img/$item/$foto",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _pageButton() {
    final List<Widget> _pageButton = <Widget>[];

    if (_loadingProdukAll == 1) {
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
                  // ignore: unnecessary_statements
                  null;
                } else if (_pageNumberIndex == 2 && i == 2) {
                  // ignore: unnecessary_statements
                  null;
                } else if (_pageNumberIndex == 3 && i == 3) {
                  // ignore: unnecessary_statements
                  null;
                } else {
                  setState(() {
                    _pageNumberIndex = i;
                    // _pageNumber = i;
                  });
                  _ambilProdukAll(context, i, '', _cekFilter);
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
              _ambilProdukAll(context, _pageNumberIndex - 1, '', _cekFilter);
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
              _ambilProdukAll(context, 1, '', _cekFilter);
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
              _ambilProdukAll(context, _pageNumber, '', _cekFilter);
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
              _ambilProdukAll(context, _pageNumberIndex + 1, '', _cekFilter);
            },
            child: const Text('>'),
          ),
        );
      }
    } else {
      _pageButton.add(const SizedBox());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _pageButton,
    );
  }
}
