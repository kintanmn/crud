import 'dart:convert';
import 'dart:io';

import 'package:crud/list_data.dart';
import 'package:crud/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);

  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final judulController = TextEditingController();
  final isiController = TextEditingController();

  Future postData(String judul, String isi) async {

    String url = Platform.isAndroid
        ? 'http://192.168.0.107/api_flutter/index.php'
        : 'http://localhost/api_flutter/index.php';
    //String url = 'http://127.0.0.1/apiTrash/prosesLoginDriver.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody = '{"judul": "$judul", "isi": "$isi"}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Catatan'),
      ),
      drawer: const SideMenu(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: judulController,
              decoration: const InputDecoration(
                hintText: 'Judul',
              ),
            ),
            TextField(
              controller: isiController,
              decoration: const InputDecoration(
                hintText: 'Isi Catatan',
              ),
            ),
            ElevatedButton(
              child: const Text('Tambah Catatan'),
              onPressed: () {
                String judul = judulController.text;
                String isi = isiController.text;

                postData(judul, isi).then((result) {
                  //print(result['pesan']);
                  if (result['pesan'] == 'berhasil') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          //var namauser2 = namauser;
                          return AlertDialog(
                            title: const Text('Data berhasil di tambahkan'),
                            content: const Text('ok'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ListData(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        });
                  }
                  setState(() {});
                });
              },
            ),
          ],
        ),

        //     ],
        //   ),
        // ),
      ),
    );
  }
}
