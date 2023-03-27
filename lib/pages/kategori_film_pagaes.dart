import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:perpustakaan/global/my_global.dart';
import 'package:perpustakaan/pages/add_buku_pages.dart';
import 'package:perpustakaan/pages/detail_book.dart';
import 'package:perpustakaan/providers/data_provider.dart';
import 'package:perpustakaan/widgets/add_edit_data_widget.dart';
import 'package:perpustakaan/widgets/add_edit_kategori_widget.dart';
import 'package:provider/provider.dart';

class MyCategoryFilm extends StatelessWidget {
  const MyCategoryFilm({super.key});

  static const Color firstColor = Color(0xffFFFDE8);

  static const Color secondColor = Color(0xffF7E0A3);

  static const Color thirdColor = Color(0xffF09C67);

  static const Color fourthColor = Color(0xff4C8492);

  static const Color whiteColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: firstColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.black,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AddEditKategoriWidget(
                        title: "Add Kategori Film",
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.library_add,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                alignment: Alignment.topLeft,
                child: const Text(
                  "List Kategori Film",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sifonn'),
                ),
              ),
              Consumer<DataProvider>(
                builder: (context, dataProvider, child) {
                  return Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: dataProvider.kategori.map((kategori) {
                        log(jsonEncode(kategori));
                        return Card(
                          color: GLobalVar.fourthColor,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 280,
                                child: ListTile(
                                  title: Text(
                                    kategori.kategori,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AddEditKategoriWidget(
                                          title: "Edit Kategori",
                                          kategori: kategori,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Alert"),
                                          content: const Text(
                                              'Apakah anda yakin menghapus kategori ini ?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cencel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Provider.of<DataProvider>(
                                                        context,
                                                        listen: false)
                                                    .removeKategori(kategori);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Ok"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
