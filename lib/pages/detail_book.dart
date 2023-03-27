import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:perpustakaan/global/my_global.dart';
import 'package:perpustakaan/global/my_global_func.dart';
import 'package:perpustakaan/models/buku_model.dart';
import 'package:perpustakaan/pages/add_buku_pages.dart';
import 'package:perpustakaan/pages/buku_pages.dart';
import 'package:perpustakaan/pages/peminjaman_pages.dart';
import 'package:perpustakaan/pages/peminjaman_paginate_pages.dart';
import 'package:perpustakaan/providers/api_provider.dart';
import 'package:perpustakaan/providers/buku_provider.dart';
import 'package:perpustakaan/providers/peminjaman_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class DetailBook extends StatefulWidget {
  const DetailBook({super.key, required this.buku, required this.kategori});

  static RoundedLoadingButtonController _pinjamButton =
      RoundedLoadingButtonController();

  final BukuModel buku;
  final String kategori;

  static int imageHeight = 0;
  static int imageWidth = 0;

  @override
  State<DetailBook> createState() => _DetailBookState();
}

class _DetailBookState extends State<DetailBook> {
  Future<ui.Image> getImage(path) async {
    final Image image = Image.network(path);
    Completer<ui.Image> completer = Completer<ui.Image>();
    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo image, bool _) {
      completer.complete(image.image);
    }));
    ui.Image info = await completer.future;
    setState(() {
      DetailBook.imageHeight = info.height;
      DetailBook.imageWidth = info.width;
    });
    return info;
  }

  @override
  void initState() {
    super.initState();
    getImage('${GLobalVar.base_url}storage/${widget.buku.path}');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(149, 0, 0, 0),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          actions: <Widget>[
            Consumer<ApiProvider>(
              builder: (context, dataProvider, child) {
                if (dataProvider.roleUser == "admin") {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 1),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(149, 0, 0, 0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Alert"),
                                content: const Text(
                                    'Apakah anda yakin menghapus buku ini ?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cencel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      );
                                      await Provider.of<BookProvider>(context,
                                              listen: false)
                                          .deleteBuku(widget.buku.id);
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => const MyBook(),
                                        ),
                                      );
                                    },
                                    child: const Text("Ok"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            Consumer<ApiProvider>(
              builder: (context, dataProvider, child) {
                if (dataProvider.roleUser == "admin") {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 1),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(149, 0, 0, 0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddBook(
                                dataBuku: widget.buku,
                                judulForm: "Edit Buku",
                              ),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.edit_note,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  height: 500,
                  width: screenWidth,
                  child: Image.network(
                    '${GLobalVar.base_url}storage/${widget.buku.path}',
                    fit: DetailBook.imageHeight > DetailBook.imageWidth
                        ? BoxFit.fitWidth
                        : BoxFit.fitHeight,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Chip(
                  backgroundColor: GLobalVar.secondColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  label: Text(
                    widget.kategori,
                    style: const TextStyle(
                        fontFamily: 'Sifonn', color: GLobalVar.thirdColor2),
                  ),
                ),
              ),
              Text(
                widget.buku.judul,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "by ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.buku.pengarang,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      children: <TextSpan>[
                        const TextSpan(text: "tahun : "),
                        TextSpan(text: widget.buku.tahun),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      children: <TextSpan>[
                        const TextSpan(text: "stok : "),
                        TextSpan(text: widget.buku.stok.toString()),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.only(top: 30),
                alignment: Alignment.topLeft,
                child: const Text(
                  "Introduction",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.only(top: 20, bottom: 80),
                alignment: Alignment.center,
                child: Text(
                  GlobalFunc.textLorem(3, 200),
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
            width: screenWidth,
            height: 50,
            padding: const EdgeInsets.only(left: 30),
            child: Consumer2<ApiProvider, PeminjamanProvider>(
              builder: (context, apiValue, peminjamanValue, child) {
                if (apiValue.roleUser == 'member') {
                  return RoundedLoadingButton(
                    controller: DetailBook._pinjamButton,
                    onPressed: () async {
                      var pinjamBuku = await Provider.of<PeminjamanProvider>(
                              context,
                              listen: false)
                          .pinjamBuku(
                        apiValue.userId,
                        widget.buku.id,
                      );

                      DetailBook._pinjamButton.success();
                      Timer(const Duration(seconds: 1), () {
                        DetailBook._pinjamButton.reset();
                      });

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Alert"),
                            content: Text(pinjamBuku),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  if (peminjamanValue.isSuccess) {
                                    Timer(const Duration(seconds: 1), () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MyPeminjamanPage(),
                                        ),
                                      );
                                    });
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text("Oke"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text("Pinjam Buku"),
                  );
                } else {
                  return Container();
                }
              },
            )),
      ),
    );
  }
}
