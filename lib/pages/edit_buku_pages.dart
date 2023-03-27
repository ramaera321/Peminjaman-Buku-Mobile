import 'package:flutter/material.dart';
import 'package:perpustakaan/global/my_global.dart';
import 'package:search_choices/search_choices.dart';

class EditBook extends StatefulWidget {
  static final TextEditingController _judulController = TextEditingController();
  static final TextEditingController _pengarangController =
      TextEditingController();
  static final TextEditingController _penerbitController =
      TextEditingController();
  static final TextEditingController _tahunController = TextEditingController();
  static final TextEditingController _stokController = TextEditingController();
  static final TextEditingController _gambarController =
      TextEditingController();

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  String? selectedKategori = null;

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
                  child: const Text(
                    "Tambah Buku",
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Form(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(bottom: 5),
                          child: const Text(
                            "Judul Buku",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextFormField(
                          controller: EditBook._judulController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Masukkan judul buku",
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(bottom: 5),
                          child: const Text(
                            "Kategori",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SearchChoices.single(
                          items: [
                            DropdownMenuItem(
                              child: Text("Kategori 1"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Kategori 2"),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text("Kategori 3"),
                              value: 3,
                            ),
                          ],
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
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(bottom: 5),
                          child: const Text(
                            "Pengarang",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextFormField(
                          controller: EditBook._pengarangController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Masukkan pengarang buku",
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(bottom: 5),
                          child: const Text(
                            "Penerbit",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextFormField(
                          controller: EditBook._penerbitController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Masukkan penerbit buku",
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(bottom: 5),
                          child: const Text(
                            "Tahun",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextFormField(
                          controller: EditBook._tahunController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Masukkan Tahun",
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(bottom: 5),
                          child: const Text(
                            "Stok",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextFormField(
                          controller: EditBook._stokController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Masukkan stok buku",
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: screenWidth,
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () {}, child: const Text("Submit")),
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
