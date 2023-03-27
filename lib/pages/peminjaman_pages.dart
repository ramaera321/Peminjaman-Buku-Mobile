import 'dart:async';

import 'package:flutter/material.dart';
import 'package:perpustakaan/pages/dashboard.dart';
import 'package:perpustakaan/providers/api_provider.dart';
import 'package:perpustakaan/providers/peminjaman_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});

  static RoundedLoadingButtonController _actionButton =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              alignment: Alignment.topLeft,
              child: const Text(
                "List Peminjaman",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sifonn'),
              ),
            ),
            Consumer2<ApiProvider, PeminjamanProvider>(
              builder: (context, dataApi, dataProvider, child) {
                return Container(
                  height: screenHeight * 0.83,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        children: dataProvider.dataPeminjaman.map(
                          (peminjaman) {
                            return Card(
                              child: Container(
                                padding: const EdgeInsets.only(right: 15),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: ListTile(
                                        title: Text(peminjaman.buku.judul),
                                        subtitle: Text(peminjaman.member.name),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Chip(
                                          backgroundColor:
                                              dataProvider.getColor(
                                                  peminjaman.status,
                                                  peminjaman
                                                      .tanggalPengembalian),
                                          label: Text(
                                              dataProvider.getStatusPeminjaman(
                                                  peminjaman.status,
                                                  peminjaman
                                                      .tanggalPengembalian),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color:
                                                      dataProvider.colorText)),
                                        ),
                                      ),
                                    ),
                                    Consumer2<ApiProvider, PeminjamanProvider>(
                                      builder: (context, apiValue,
                                          peminjamanValue, child) {
                                        return SizedBox(
                                          width: 70,
                                          height: 40,
                                          child: RoundedLoadingButton(
                                            controller: _actionButton,
                                            color: apiValue.roleUser == 'admin'
                                                ? peminjaman.status == "1"
                                                    ? Colors.green.shade600
                                                    : Colors.grey
                                                : peminjaman.status == "2"
                                                    ? Colors.blue.shade600
                                                    : Colors.grey,
                                            onPressed: peminjamanValue
                                                        .isLoading ||
                                                    (!(apiValue.roleUser ==
                                                                'admin' &&
                                                            peminjaman.status ==
                                                                '1') &&
                                                        !(apiValue.roleUser ==
                                                                "member" &&
                                                            peminjaman.status ==
                                                                '2'))
                                                ? null
                                                : () async {
                                                    if (apiValue.roleUser ==
                                                            'admin' &&
                                                        peminjaman.status ==
                                                            '1') {
                                                      await Provider.of<
                                                                  PeminjamanProvider>(
                                                              context,
                                                              listen: false)
                                                          .acceptPinjamBuku(
                                                              peminjaman.id);

                                                      _actionButton.success();
                                                      Timer(
                                                          const Duration(
                                                              seconds: 1), () {
                                                        _actionButton.reset();
                                                      });

                                                      if (peminjamanValue
                                                          .isSuccess) {
                                                        Timer(
                                                          const Duration(
                                                              seconds: 1),
                                                          () {
                                                            Navigator.of(
                                                                    context)
                                                                .pushReplacement(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const PeminjamanPage(),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    } else if (apiValue
                                                                .roleUser ==
                                                            "member" &&
                                                        peminjaman.status ==
                                                            '2') {
                                                      await Provider.of<
                                                                  PeminjamanProvider>(
                                                              context,
                                                              listen: false)
                                                          .returnPinjamBuku(
                                                              peminjaman.id);

                                                      _actionButton.success();
                                                      Timer(
                                                          const Duration(
                                                              seconds: 1), () {
                                                        _actionButton.reset();
                                                      });

                                                      if (peminjamanValue
                                                          .isSuccess) {
                                                        Timer(
                                                          const Duration(
                                                              seconds: 1),
                                                          () {
                                                            Navigator.of(
                                                                    context)
                                                                .pushReplacement(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const PeminjamanPage(),
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
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
