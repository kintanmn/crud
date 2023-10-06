import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crud/edit_data.dart';
import 'package:crud/read_data.dart';
import 'package:crud/side_menu.dart';
import 'package:crud/tambah_data.dart';


class ListData extends StatefulWidget {
  const ListData({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<Map<String, String>> dataCatatan = [];
  String url = Platform.isAndroid
      ? 'http://192.168.0.107/api_flutter/index.php'
      : 'http://localhost/api_flutter/index.php';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataCatatan = List<Map<String, String>>.from(data.map((item) {
          return {
            'judul': item['judul'] as String,
            'isi': item['isi'] as String,
            'id': item['id'] as String,
          };
        }));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Catatan'),
      ),
      drawer: const SideMenu(),
      body: Column(children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TambahData(),
              ),
            );
          },
          child: const Text('Tambah Data Catatan'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: dataCatatan.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataCatatan[index]['judul']!),
                subtitle: Text('Isi : ${dataCatatan[index]['isi']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        //editCatatan(index);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditData(
                                id: dataCatatan[index]['id'].toString(),
                                judul: dataCatatan[index]['judul'] as String,
                                isi: dataCatatan[index]['isi']
                                    as String)));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        //lihatCatatan(index);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ReadData(
                                id: dataCatatan[index]['id'].toString(),
                                judul: dataCatatan[index]['judul'] as String,
                                isi: dataCatatan[index]['isi']
                                    as String)));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteData(int.parse(dataCatatan[index]['id']!))
                            .then((result) {
                          if (result['pesan'] == 'berhasil') {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Data berhasil di hapus'),
                                    content: const Text('ok'),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                              const ListData(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ]),
    );
  }
}
