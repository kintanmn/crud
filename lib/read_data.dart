import 'package:flutter/material.dart';

class ReadData extends StatelessWidget {
  final String id;
  final String judul;
  final String isi;

  const ReadData(
      {Key? key, required this.id, required this.judul, required this.isi})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lihat Data Catatan"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Text(
              'ID: $id',
              style: const TextStyle(
                fontSize: 18, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Add emphasis with bold text
              ),
            ),
            const SizedBox(
              height: 10,
            ), // Add some spacing between the text widgets
            Text(
              'Judul: $judul',
              style: const TextStyle(
                fontSize: 16, // Adjust the font size as needed
              ),
            ),
            const SizedBox(height: 5), // Add a smaller spacing
            Text(
              'Isi: $isi',
              style: const TextStyle(
                fontSize: 16, // Adjust the font size as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
