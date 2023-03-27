import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:perpustakaan/models/film_model.dart';
import 'package:perpustakaan/providers/data_provider.dart';
import 'package:perpustakaan/widgets/add_edit_data_widget.dart';
import 'package:perpustakaan/widgets/add_edit_kategori_widget.dart';
import 'package:provider/provider.dart';

class MyFilm extends StatelessWidget {
  static const Color firstColor = Color(0xffFFFDE8);

  static const Color secondColor = Color(0xffF7E0A3);

  static const Color thirdColor = Color(0xffF09C67);

  static const Color fourthColor = Color(0xff4C8492);

  static const Color whiteColor = Colors.white;

  List<FilmModel> dataCategory = [];

  @override
  Widget build(BuildContext context) {
    String? filterValue = null;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: firstColor,
        appBar: AppBar(
          title: const Text("List Film"),
          backgroundColor: fourthColor,
          leading: BackButton(
            color: firstColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Consumer<DataProvider>(builder: (context, value, child) {
              log(jsonEncode(value.kategoriFilter));
              return StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                      height: 60,
                      child: ListView(
                        children: [
                          Card(
                            margin: const EdgeInsets.all(10),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 10, left: 10),
                              child: Row(
                                children: [
                                  const Text("Filter :"),
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: DropdownButton(
                                      items:
                                          value.kategoriFilter.map((kategori) {
                                        return DropdownMenuItem<String>(
                                          child: Text(kategori.kategori),
                                          value: kategori.id,
                                        );
                                      }).toList(),
                                      onChanged: (String? val) {
                                        setState(() {
                                          filterValue = val;
                                        });
                                        Provider.of<DataProvider>(context,
                                                listen: false)
                                            .filterCategory(val);
                                      },
                                      hint: const Text("Kategori"),
                                      value: filterValue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ));
                },
              );
            }),
            const SizedBox(
              height: 10,
            ),
            Consumer<DataProvider>(builder: (
              context,
              dataProvider,
              child,
            ) {
              return Expanded(
                child: ListView(
                    children: dataProvider.dataCategory.isEmpty
                        ? dataProvider.kategori.isNotEmpty
                            ? dataProvider.kategori.map((kategori) {
                                dataCategory.clear();
                                dataProvider.data.forEach((d) {
                                  if (d.kategori == kategori.id) {
                                    dataCategory.add(d);
                                  }
                                });
                                return Column(
                                  children: [
                                    Card(
                                      margin: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                right: 20, left: 20),
                                            child: Row(
                                              children: [
                                                Text(kategori.kategori),
                                                TextButton(
                                                  onPressed: () {
                                                    Provider.of<DataProvider>(
                                                            context,
                                                            listen: false)
                                                        .removeKategori(
                                                            kategori);
                                                  },
                                                  child: Text('Hapus Kategori'),
                                                  style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.red.shade600),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: ListView(
                                              physics: ClampingScrollPhysics(),
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              shrinkWrap: true,
                                              children: dataProvider
                                                      .data.isNotEmpty
                                                  ? dataCategory.map((data) {
                                                      // log(jsonEncode(dataCategory));
                                                      return Dismissible(
                                                        key: Key(data.id),
                                                        background: Container(
                                                          color: Colors
                                                              .red.shade300,
                                                          child: const Center(
                                                            child: Text(
                                                              "Hapus?",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                        child: Card(
                                                          child: ListTile(
                                                            title:
                                                                Text(data.name),
                                                            onTap: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AddEditDataWidget(
                                                                      title:
                                                                          "Edit Data",
                                                                      data:
                                                                          data,
                                                                    );
                                                                  });
                                                            },
                                                          ),
                                                        ),
                                                        onDismissed:
                                                            (direction) {
                                                          Provider.of<DataProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .removeData(data);
                                                        },
                                                      );
                                                    }).toList()
                                                  : [
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height,
                                                          child: const Center(
                                                            child: Text(
                                                              "Data masih kosong",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ))
                                                    ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                );
                              }).toList()
                            : [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width,
                                    child: const Center(
                                      child: Text(
                                        "Data masih kosong",
                                        textAlign: TextAlign.center,
                                      ),
                                    ))
                              ]
                        : dataProvider.dataCategory.isNotEmpty
                            ? dataProvider.dataCategory.map((kategori) {
                                dataCategory.clear();
                                dataProvider.data.forEach((d) {
                                  if (d.kategori == kategori.id) {
                                    dataCategory.add(d);
                                  }
                                });
                                return Column(
                                  children: [
                                    Container(
                                      child: Card(
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                          left: 10,
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  right: 20, left: 20),
                                              child: Row(
                                                children: [
                                                  Text(kategori.kategori),
                                                  TextButton(
                                                    onPressed: () {
                                                      Provider.of<DataProvider>(
                                                              context,
                                                              listen: false)
                                                          .removeKategori(
                                                              kategori);
                                                    },
                                                    child:
                                                        Text('Hapus Kategori'),
                                                    style: TextButton.styleFrom(
                                                        foregroundColor: Colors
                                                            .red.shade600),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: ListView(
                                                physics:
                                                    ClampingScrollPhysics(),
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                shrinkWrap: true,
                                                children: dataProvider
                                                        .data.isNotEmpty
                                                    ? dataCategory.map((data) {
                                                        // log(jsonEncode(dataCategory));
                                                        return Dismissible(
                                                          key: Key(data.id),
                                                          background: Container(
                                                            color: Colors
                                                                .red.shade300,
                                                            child: const Center(
                                                              child: Text(
                                                                "Hapus?",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          child: Card(
                                                            child: ListTile(
                                                              title: Text(
                                                                  data.name),
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AddEditDataWidget(
                                                                        title:
                                                                            "Edit Data",
                                                                        data:
                                                                            data,
                                                                      );
                                                                    });
                                                              },
                                                            ),
                                                          ),
                                                          onDismissed:
                                                              (direction) {
                                                            Provider.of<DataProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .removeData(
                                                                    data);
                                                          },
                                                        );
                                                      }).toList()
                                                    : [
                                                        const SizedBox(
                                                            height: 30,
                                                            child: Center(
                                                              child: Text(
                                                                "Data masih kosong",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ))
                                                      ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                );
                              }).toList()
                            : [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    child: const Center(
                                      child: Text(
                                        "Data masih kosong",
                                        textAlign: TextAlign.center,
                                      ),
                                    ))
                              ]),
              );
            }),
            FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AddEditKategoriWidget(
                          title: "Tambah Kategori");
                    });
              },
              label: const Text("Tambah Kategori"),
              icon: const Icon(Icons.add),
            ),
            const SizedBox(
              height: 20,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AddEditDataWidget(title: "Tambah FIlm");
                    });
              },
              label: const Text("Tambah FIlm"),
              icon: const Icon(Icons.add),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
