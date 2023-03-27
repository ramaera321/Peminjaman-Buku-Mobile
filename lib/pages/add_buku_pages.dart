import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/global/my_global.dart';
import 'package:perpustakaan/models/buku_model.dart';
import 'package:perpustakaan/pages/buku_pages.dart';
import 'package:perpustakaan/providers/buku_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:search_choices/search_choices.dart';

class AddBook extends StatefulWidget {
  final BukuModel? dataBuku;
  final String judulForm;
  const AddBook({super.key, required this.judulForm, this.dataBuku});

  static final TextEditingController _judulController = TextEditingController();
  static final TextEditingController _pengarangController =
      TextEditingController();
  static final TextEditingController _penerbitController =
      TextEditingController();
  static final TextEditingController _tahunController = TextEditingController();
  static final TextEditingController _stokController = TextEditingController();
  static final TextEditingController _gambarController =
      TextEditingController();
  static final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();
  static String _image = "null";
  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  int? selectedKategori = null;
  File? imagePickerVal;
  static TextEditingController _imagePickerText = TextEditingController();

  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'JPG', 'JPEG', 'PNG']);
    if (result != null) {
      setState(() {
        _imagePickerText.text = result.files.single.name;
        imagePickerVal = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.dataBuku != null) {
      selectedKategori = widget.dataBuku!.categoryId;
      AddBook._judulController.text = widget.dataBuku!.judul;
      AddBook._pengarangController.text = widget.dataBuku!.pengarang;
      AddBook._penerbitController.text = widget.dataBuku!.penerbit;
      AddBook._tahunController.text = widget.dataBuku!.tahun;
      AddBook._stokController.text = (widget.dataBuku!.stok).toString();
      AddBook._image = '${GLobalVar.base_url}storage/${widget.dataBuku!.path}';
      _imagePickerText.text = widget.dataBuku!.path!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: GLobalVar.secondColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _imagePickerText.clear();
                imagePickerVal = null;
                Navigator.of(context).pop();
              },
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.judulForm,
                    style: TextStyle(fontSize: 24, fontFamily: 'Sifonn'),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Isi semua input form yang memiliki tanda *",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: screenWidth,
                  margin: const EdgeInsets.only(top: 20, bottom: 40),
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Form(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 27, right: 27),
                          child: const Text(
                            "Judul Buku",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFormField(
                            controller: AddBook._judulController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Masukkan judul buku",
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 27, right: 27),
                          child: const Text(
                            "Kategori",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Consumer<BookProvider>(
                            builder: (context, dataProvider, child) {
                              return SearchChoices.single(
                                items: dataProvider.kategoriBuku
                                    .map((kategori) => DropdownMenuItem(
                                          child: Text(kategori.namaKategori),
                                          value: kategori.id,
                                        ))
                                    .toList(),
                                fieldDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                value: selectedKategori,
                                hint: "Select Kategori",
                                searchHint: "Select Kategori",
                                onChanged: (value) {
                                  setState(() {
                                    selectedKategori = value;
                                  });
                                },
                                isExpanded: true,
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 27, right: 27),
                          child: const Text(
                            "Pengarang",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFormField(
                            controller: AddBook._pengarangController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Masukkan pengarang buku",
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 27, right: 27),
                          child: const Text(
                            "Penerbit",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFormField(
                            controller: AddBook._penerbitController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Masukkan penerbit buku",
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 27, right: 27),
                          child: const Text(
                            "Tahun",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFormField(
                            controller: AddBook._tahunController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Masukkan Tahun",
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 27, right: 27),
                          child: const Text(
                            "Stok",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextFormField(
                            controller: AddBook._stokController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Masukkan stok buku",
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 27, right: 27),
                          child: const Text(
                            "Gambar",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        imagePickerVal != null
                            ? Container(
                                width: 200,
                                height: 150,
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    imagePickerVal!,
                                    // width: 100,
                                    // fit: BoxFit.fitWidth,
                                  ),
                                ),
                              )
                            : AddBook._image != "null"
                                ? Container(
                                    width: 200,
                                    height: 150,
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 20),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        style: BorderStyle.solid,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        AddBook._image,
                                        // width: 100,
                                        // fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  )
                                : Container(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              Container(
                                width: 220,
                                child: TextFormField(
                                  controller: _imagePickerText,
                                  enabled: false,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  ),
                                ),
                              ),
                              Container(
                                  width: 75,
                                  height: 48,
                                  margin: const EdgeInsets.only(left: 5),
                                  child: ElevatedButton(
                                    child: const Text("Pilih"),
                                    onPressed: () async {
                                      await selectFile();
                                    },
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Consumer<BookProvider>(
                          builder: (context, dataProvider, child) {
                            return Container(
                              width: screenWidth,
                              height: 45,
                              child: RoundedLoadingButton(
                                controller: AddBook._buttonController,
                                onPressed: dataProvider.isLoading
                                    ? null
                                    : () async {
                                        if (widget.dataBuku != null) {
                                          await Provider.of<BookProvider>(
                                                  context,
                                                  listen: false)
                                              .updateBuku(
                                            (widget.dataBuku!.id).toString(),
                                            AddBook._judulController.text,
                                            selectedKategori.toString(),
                                            AddBook._pengarangController.text,
                                            AddBook._penerbitController.text,
                                            AddBook._tahunController.text,
                                            AddBook._stokController.text,
                                            imagePickerVal,
                                          );
                                        } else {
                                          await Provider.of<BookProvider>(
                                                  context,
                                                  listen: false)
                                              .createBuku(
                                            AddBook._judulController.text,
                                            selectedKategori.toString(),
                                            AddBook._pengarangController.text,
                                            AddBook._penerbitController.text,
                                            AddBook._tahunController.text,
                                            AddBook._stokController.text,
                                            imagePickerVal!,
                                          );
                                        }

                                        AddBook._buttonController.success();
                                        Timer(const Duration(seconds: 1), () {
                                          AddBook._buttonController.reset();
                                        });
                                        if (dataProvider.isSuccess) {
                                          Timer(const Duration(seconds: 1), () {
                                            AddBook._judulController.clear();
                                            selectedKategori = null;
                                            AddBook._pengarangController
                                                .clear();
                                            AddBook._penerbitController.clear();
                                            AddBook._tahunController.clear();
                                            AddBook._stokController.clear();

                                            _imagePickerText.clear();
                                            imagePickerVal = null;
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const MyBook(),
                                              ),
                                            );
                                          });
                                        }
                                      },
                                child: const Text("Submit"),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
