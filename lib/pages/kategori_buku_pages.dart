// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:perpustakaan/global/my_global.dart';
import 'package:perpustakaan/pages/add_buku_pages.dart';
import 'package:perpustakaan/pages/detail_book.dart';
import 'package:perpustakaan/providers/buku_provider.dart';
import 'package:perpustakaan/providers/data_provider.dart';
import 'package:perpustakaan/widgets/add_edit_data_widget.dart';
import 'package:perpustakaan/widgets/add_edit_kategori_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/add_edit_kategori_buku_widget.dart';

class MyCategoryBook extends StatefulWidget {
  const MyCategoryBook({super.key});

  @override
  State<MyCategoryBook> createState() => _MyCategoryBookState();
}

class _MyCategoryBookState extends State<MyCategoryBook> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<BookProvider>(context, listen: false).getKategoriBook();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: GLobalVar.firstColor,
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
                      return const AddEditKategoriBookWidget(
                        title: "Add Kategori Buku",
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
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 17, right: 17),
                alignment: Alignment.topLeft,
                child: const Text(
                  "List Kategori Buku",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sifonn'),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: TextField(
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Cari Kategori . . .",
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      ),
                      onSubmitted: (value) {
                        Provider.of<BookProvider>(context, listen: false)
                            .searchKategori(value);
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: screenHeight * 0.72,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: SingleChildScrollView(
                  child: Consumer<BookProvider>(
                    builder: (context, dataProvider, child) {
                      return Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: dataProvider.listKategori.map((kategori) {
                            return Card(
                              color: GLobalVar.fourthColor,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 280,
                                    child: ListTile(
                                      title: Text(
                                        kategori.namaKategori,
                                        style: const TextStyle(
                                            color: Colors.white),
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
                                            return AddEditKategoriBookWidget(
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
                                                    Provider.of<BookProvider>(
                                                            context,
                                                            listen: false)
                                                        .deleteKategoriBuku(
                                                            kategori.id);
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
                ),
              ),
              Consumer<BookProvider>(
                builder: (context, dataPaginate, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: dataPaginate.dataPaginations
                            .map((e) => Container(
                                  child: ElevatedButton(
                                    child: Text(
                                      e.label,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: dataPaginate.currentPage
                                                    .toString() ==
                                                e.label
                                            ? Color.fromARGB(255, 61, 105, 117)
                                            : GLobalVar.fourthColor),
                                    onPressed: e.url == null
                                        ? null
                                        : () async {
                                            if (dataPaginate.currentPage
                                                    .toString() !=
                                                e.label) {
                                              await Provider.of<BookProvider>(
                                                      context,
                                                      listen: false)
                                                  .paginationKategori(e.url);
                                            }
                                          },
                                  ),
                                ))
                            .toList()),
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
