// ignore_for_file: unused_import, unnecessary_const

import 'dart:convert';
import 'dart:developer';

import 'package:perpustakaan/models/film_model.dart';
import 'package:perpustakaan/widgets/dialog_alert.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';

class AddEditDataWidget extends StatefulWidget {
  final String title;
  final FilmModel? data;
  const AddEditDataWidget({
    Key? key,
    required this.title,
    this.data,
  }) : super(key: key);

  @override
  State<AddEditDataWidget> createState() => _AddEditDataWidgetState();
}

class _AddEditDataWidgetState extends State<AddEditDataWidget> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _dataController = TextEditingController();
    TextEditingController _kategoriController = TextEditingController();
    String? dropdownValue = null;

    if (widget.data != null) {
      _dataController.text = widget.data!.name;
    }
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text(widget.title),
          content: SingleChildScrollView(
              child: Column(
            children: [
              TextField(
                controller: _dataController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  isDense: true,
                  fillColor: Colors.grey.shade100,
                  labelText: "FIlm",
                  hintText: "Masukkan Nama Film",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Consumer<DataProvider>(builder: (context, dataProvider, child) {
                log(jsonEncode(dropdownValue));
                return DropdownButton<String>(
                  isExpanded: true,
                  items: dataProvider.kategori.map((kategori) {
                    return DropdownMenuItem<String>(
                      child: Text(kategori.kategori),
                      value: kategori.id,
                    );
                  }).toList(),
                  // value: _kategoriController,
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value;
                    });
                    // dataProvider.dropdownValue = newValue;
                  },
                  value: dropdownValue,
                  hint: Text("Kategori"),
                );
              })
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
                if (_dataController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const DialogAlert(
                          title: "Error!",
                          message: "Error! Data tidak boleh kosong.");
                    },
                  );
                } else {
                  // log(jsonEncode(data));
                  if (widget.data != null) {
                    Provider.of<DataProvider>(context, listen: false)
                        .updateData(
                      FilmModel(
                          id: widget.data!.id,
                          name: _dataController.text,
                          kategori: dropdownValue!),
                    );
                    Navigator.pop(context);
                  } else {
                    const uuid = Uuid();

                    Provider.of<DataProvider>(context, listen: false).addData(
                      FilmModel(
                          id: uuid.v4(),
                          name: _dataController.text,
                          kategori: dropdownValue!),
                    );
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }
}
