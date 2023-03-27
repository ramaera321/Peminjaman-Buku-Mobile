import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:perpustakaan/models/peminjaman_model.dart';
import 'package:perpustakaan/pages/dashboard.dart';
import 'package:perpustakaan/pages/peminjaman_pages.dart';
import 'package:perpustakaan/providers/api_provider.dart';
import 'package:perpustakaan/providers/peminjaman_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class MyPeminjamanPage extends StatefulWidget {
  const MyPeminjamanPage({super.key});

  @override
  State<MyPeminjamanPage> createState() => _MyPeminjamanPageState();
}

class _MyPeminjamanPageState extends State<MyPeminjamanPage> {
  int perPage = 9;

  static RoundedLoadingButtonController _actionButton =
      RoundedLoadingButtonController();

  final PagingController<int, PeminjamanModel> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> _getData(int page) async {
    try {
      final List<PeminjamanModel> dataPeminjaman =
          await Provider.of<PeminjamanProvider>(context, listen: false)
              .getPeminjamanPaginate(page, perPage);
      final isLastPage = dataPeminjaman.length < perPage;
      if (isLastPage) {
        _pagingController.appendLastPage(dataPeminjaman);
      } else {
        _pagingController.appendPage(dataPeminjaman, page + 1);
      }
    } catch (e) {
      _pagingController.error = "gagal mengambil data buku";
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener(
      (pageKey) => _getData(pageKey),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.only(left: 17, right: 17, bottom: 10),
          alignment: Alignment.topLeft,
          child: const Text(
            "List Peminjaman",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Sifonn'),
          ),
        ),
        Container(
          height: screenHeight * 0.83,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: PagedListView(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<PeminjamanModel>(
              itemBuilder: (context, item, index) {
                return Card(
                  child: Consumer2<ApiProvider, PeminjamanProvider>(
                    builder: (context, apiValue, peminjamanValue, child) {
                      return Container(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: ListTile(
                                title: Text(item.buku.judul),
                                subtitle: Text(item.member.name),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Chip(
                                  backgroundColor: peminjamanValue.getColor(
                                      item.status, item.tanggalPengembalian),
                                  label: Text(
                                      peminjamanValue.getStatusPeminjaman(
                                          item.status,
                                          item.tanggalPengembalian),
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: peminjamanValue.colorText)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 70,
                              height: 40,
                              child: RoundedLoadingButton(
                                controller: _actionButton,
                                color: apiValue.roleUser == 'admin'
                                    ? item.status == "1"
                                        ? Colors.green.shade600
                                        : Colors.grey
                                    : item.status == "2"
                                        ? Colors.blue.shade600
                                        : Colors.grey,
                                onPressed: (peminjamanValue.getStatusDate(
                                            item.tanggalPengembalian)) ||
                                        (!(apiValue.roleUser == 'admin' &&
                                                item.status == '1') &&
                                            !(apiValue.roleUser == "member" &&
                                                item.status == '2'))
                                    ? null
                                    : () async {
                                        if (apiValue.roleUser == 'admin' &&
                                            item.status == '1') {
                                          await Provider.of<PeminjamanProvider>(
                                                  context,
                                                  listen: false)
                                              .acceptPinjamBuku(item.id);

                                          _actionButton.success();
                                          Timer(const Duration(seconds: 1), () {
                                            _actionButton.reset();
                                          });

                                          if (peminjamanValue.isSuccess) {
                                            Timer(
                                              const Duration(seconds: 1),
                                              () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyPeminjamanPage(),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        } else if (apiValue.roleUser ==
                                                "member" &&
                                            item.status == '2') {
                                          await Provider.of<PeminjamanProvider>(
                                                  context,
                                                  listen: false)
                                              .returnPinjamBuku(item.id);

                                          _actionButton.success();
                                          Timer(const Duration(seconds: 1), () {
                                            _actionButton.reset();
                                          });

                                          if (peminjamanValue.isSuccess) {
                                            Timer(
                                              const Duration(seconds: 1),
                                              () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyPeminjamanPage(),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                child: apiValue.roleUser == 'admin'
                                    ? Icon(Icons.check)
                                    : Icon(Icons.restore),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
