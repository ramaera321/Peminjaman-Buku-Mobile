// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:developer';

import 'package:perpustakaan/models/kategori_film_model.dart';
import 'package:perpustakaan/widgets/dialog_alert.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';

class AddEditKategoriWidget extends StatelessWidget {
  final String title;
  final FilmKategoriModel? kategori;
  const AddEditKategoriWidget({
    Key? key,
    required this.title,
    this.kategori,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _kategoriController = TextEditingController();

    if (kategori != null) {
      _kategoriController.text = kategori!.kategori;
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
                Provider.of<DataProvider>(context, listen: false)
                    .updateKategori(
                  FilmKategoriModel(
                      id: kategori!.id, kategori: _kategoriController.text),
                );
                Navigator.pop(context);
              } else {
                const uuid = Uuid();

                Provider.of<DataProvider>(context, listen: false).addKategori(
                  FilmKategoriModel(
                      id: uuid.v4(), kategori: _kategoriController.text),
                );
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
