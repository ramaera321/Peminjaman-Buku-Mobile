import 'dart:developer';
import 'dart:io';
// import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/global/my_global.dart';
import 'package:perpustakaan/models/buku_model.dart';
import 'package:perpustakaan/pages/add_buku_pages.dart';
import 'package:perpustakaan/pages/dashboard.dart';
import 'package:perpustakaan/pages/detail_book.dart';
import 'package:perpustakaan/providers/api_provider.dart';
import 'package:perpustakaan/providers/buku_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class MyBook extends StatefulWidget {
  const MyBook({super.key});

  static const Color firstColor = Color(0xffFFFDE8);

  static const Color secondColor = Color(0xffF7E0A3);

  static const Color thirdColor = Color(0xffF09C67);

  static const Color fourthColor = Color(0xff4C8492);

  static const Color whiteColor = Colors.white;

  static RoundedLoadingButtonController _importButton =
      RoundedLoadingButtonController();

  @override
  State<MyBook> createState() => _MyBookState();
}

class _MyBookState extends State<MyBook> {
  File? filePickerVal;
  static TextEditingController txtFilePicker = TextEditingController();

  selectFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'xls']);
    if (result != null) {
      setState(() {
        txtFilePicker.text = result.files.single.name;
        filePickerVal = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<BookProvider>(context, listen: false).getBuku();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<BookProvider>(context, listen: false).getKategoriBook();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: MyBook.firstColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyDashboard()));
            },
            color: Colors.black,
          ),
          actions: <Widget>[
            Consumer2<ApiProvider, BookProvider>(
              builder: (context, dataProvider, bookProvider, child) {
                if (dataProvider.roleUser == "admin") {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Import Buku"),
                              content: SingleChildScrollView(
                                child: Container(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Container(
                                          width: 255,
                                          child: ElevatedButton(
                                            // controller: MyBook._importButton,
                                            onPressed: bookProvider.isLoading
                                                ? null
                                                : () async {
                                                    await Provider.of<
                                                                BookProvider>(
                                                            context,
                                                            listen: false)
                                                        .downloadTemplateExcel();
                                                    Navigator.of(context).pop();
                                                  },
                                            child:
                                                const Text("Download Template"),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 150,
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              child: TextFormField(
                                                enabled: false,
                                                controller: txtFilePicker,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          10, 0, 10, 0),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  await selectFile();
                                                },
                                                child: const Text("Pilih File"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cencel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await Provider.of<BookProvider>(context,
                                            listen: false)
                                        .importBuku(filePickerVal!);
                                    Navigator.of(context).pop();
                                    setState(() {
                                      txtFilePicker.clear();
                                    });
                                  },
                                  child: const Text("Import"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.upload_file_sharp,
                        color: Colors.black,
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
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Alert"),
                              content: const Text('Pilih jenis download!'),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cencel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await Provider.of<BookProvider>(context,
                                            listen: false)
                                        .downloadBukuPdf();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("PDF"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await Provider.of<BookProvider>(context,
                                            listen: false)
                                        .downloadBukuExcel();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Excel"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.download_sharp,
                        color: Colors.black,
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
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const AddBook(judulForm: "Tambah Buku"),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.library_add,
                        color: Colors.black,
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
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                alignment: Alignment.topLeft,
                child: const Text(
                  "List Buku",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sifonn'),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 10, left: 14, right: 14),
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
                        hintText: "Cari Buku . . .",
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      ),
                      onSubmitted: (value) {
                        Provider.of<BookProvider>(context, listen: false)
                            .searchBuku(value);
                      },
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Consumer<BookProvider>(
                  builder: (context, dataProvider, child) {
                    return Container(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 10),
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: dataProvider.kategoriBuku
                            .map(
                              (kategori) => Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: GLobalVar.secondColor),
                                  onPressed: () async {
                                    await Provider.of<BookProvider>(context,
                                            listen: false)
                                        .filterBuku(kategori.id);
                                  },
                                  child: Text(
                                    kategori.namaKategori,
                                    style: const TextStyle(
                                        fontFamily: 'Sifonn',
                                        color: GLobalVar.thirdColor2,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: screenHeight * 0.72,
                padding: const EdgeInsets.only(bottom: 20),
                child: SingleChildScrollView(
                  child: Consumer<BookProvider>(
                    builder: (context, dataProvider, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: dataProvider.listBuku.map(
                            (buku) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: ListTile(
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5, top: 15),
                                              child: Text(
                                                buku.judul,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: Wrap(
                                                direction: Axis.vertical,
                                                spacing: 5,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              107,
                                                              107,
                                                              107)),
                                                      children: [
                                                        TextSpan(
                                                            text: buku.stok
                                                                .toString()),
                                                        const TextSpan(
                                                            text: " Books"),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    buku.pengarang,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 60),
                                          child: Image.network(
                                            '${GLobalVar.base_url}storage/${buku.path}',
                                            height: 90,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    String kategori = Provider.of<BookProvider>(
                                            context,
                                            listen: false)
                                        .getKategoriDetail(buku.categoryId);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DetailBook(
                                          buku: buku,
                                          kategori: kategori,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
