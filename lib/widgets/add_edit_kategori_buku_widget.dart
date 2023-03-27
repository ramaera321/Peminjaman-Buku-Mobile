// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:developer';

import 'package:perpustakaan/models/kategori_buku_model.dart';
import 'package:perpustakaan/models/kategori_film_model.dart';
import 'package:perpustakaan/providers/buku_provider.dart';
import 'package:perpustakaan/widgets/dialog_alert.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';

class AddEditKategoriBookWidget extends StatelessWidget {
  final String title;
  final BookKategoriModel? kategori;
  const AddEditKategoriBookWidget({
    Key? key,
    required this.title,
    this.kategori,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _kategoriController = TextEditingController();

    if (kategori != null) {
      _kategoriController.text = kategori!.namaKategori;
    }
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
          child: Column(
        children: [
          TextField(
            controller: _kategoriController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              isDense: true,
              fillColor: Colors.grey.shade100,
              labelText: "Kategori",
              hintText: "Masukkan Kategori",
            ),
          ),
        ],
      )),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Batal"),
        ),
        TextButton(
          onPressed: () {
            if (_kategoriController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return const DialogAlert(
                      title: "Error!",
                      message: "Error! Data tidak boleh kosong.");
                },
              );
            } else {
              // log(jsonEncode(kategori));
              if (kategori != null) {
                Provider.of<BookProvider>(context, listen: false)
                    .updateKategoriBuku(kategori!.id, _kategoriController.text);
                Navigator.pop(context);
              } else {
                Provider.of<BookProvider>(context, listen: false)
                    .createKategoriBuku(_kategoriController.text);
                Navigator.pop(context);
              }
            }
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
