import 'package:flutter/material.dart';
import 'package:perpustakaan/main.dart';
import 'package:perpustakaan/models/peminjaman_model.dart';
import 'package:perpustakaan/pages/navbar.dart';
import 'package:perpustakaan/pages/navbar_member.dart';
import 'package:perpustakaan/pages/navbar_visitor.dart';
import 'package:perpustakaan/providers/api_provider.dart';
import 'package:perpustakaan/providers/buku_provider.dart';
import 'package:perpustakaan/providers/data_provider.dart';
import 'package:perpustakaan/providers/peminjaman_provider.dart';
import 'package:provider/provider.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({super.key});
  static const Color firstColor = Color(0xffFFFDE8);

  static const Color secondColor = Color(0xffF7E0A3);

  static const Color thirdColor = Color(0xffF09C67);

  static const Color fourthColor = Color(0xff4C8492);

  static const Color whiteColor = Colors.white;

  static String roleUser = "admin";

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<BookProvider>(context, listen: false).getBuku();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<BookProvider>(context, listen: false).getKategoriBook();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<ApiProvider>(context, listen: false).getMembers();
    });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await Provider.of<ApiProvider>(context, listen: false).getUsers();
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<PeminjamanProvider>(context, listen: false)
          .getPeminjaman();
    });

    MyDashboard.roleUser =
        Provider.of<ApiProvider>(context, listen: false).roleUser;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: MyDashboard.firstColor,
        drawer: MyDashboard.roleUser == "admin"
            ? NavBar()
            : MyDashboard.roleUser == "member"
                ? NavBarMember()
                : NavBarVisitor(),
        appBar: AppBar(
          backgroundColor: MyDashboard.fourthColor,
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 30,
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "My Dashboard",
                    style: TextStyle(
                      color: MyDashboard.fourthColor,
                      fontFamily: 'BebasNeue',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Data Film",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: screenWidth * 0.4,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 1,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: MyDashboard.thirdColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(left: 30),
                                margin: const EdgeInsets.only(top: 20),
                                child: Consumer<DataProvider>(
                                  builder: (context, filmProvider, child) {
                                    return Text(
                                      (filmProvider.data.length).toString(),
                                      style: const TextStyle(
                                          fontSize: 80,
                                          color: MyDashboard.firstColor,
                                          fontFamily: 'BebasNeue'),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(left: 30),
                                child: const Text(
                                  "Film",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: MyDashboard.firstColor,
                                      fontFamily: 'Sifonn'),
                                ),
                              )
                            ]),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFC93C),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(left: 30),
                              margin: const EdgeInsets.only(top: 20),
                              child: Consumer<DataProvider>(
                                builder: (context, filmProvider, child) {
                                  return Text(
                                    (filmProvider.kategori.length).toString(),
                                    style: const TextStyle(
                                        fontSize: 80,
                                        color: MyDashboard.firstColor,
                                        fontFamily: 'BebasNeue'),
                                  );
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(left: 30),
                              child: const Text(
                                "Kategori",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: MyDashboard.firstColor,
                                    fontFamily: 'Sifonn'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Data Buku",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: screenWidth * 0.4,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 1,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xff0081B4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                // height: 90,
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(left: 30),
                                margin: const EdgeInsets.only(top: 20),
                                child: Consumer<BookProvider>(
                                  builder: (context, dataProvider, child) {
                                    return Text(
                                      (dataProvider.buku.length).toString(),
                                      style: const TextStyle(
                                          fontSize: 80,
                                          color: MyDashboard.firstColor,
                                          fontFamily: 'BebasNeue'),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(left: 30),
                                child: const Text(
                                  "Buku",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: MyDashboard.firstColor,
                                      fontFamily: 'Sifonn'),
                                ),
                              )
                            ]),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xff28bcff),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(left: 30),
                              margin: const EdgeInsets.only(top: 20),
                              child: Consumer<BookProvider>(
                                builder: (context, filmProvider, child) {
                                  return Text(
                                    (filmProvider.kategoriBuku.length)
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 80,
                                        color: MyDashboard.firstColor,
                                        fontFamily: 'BebasNeue'),
                                  );
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(left: 30),
                              child: const Text(
                                "Kategori",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: MyDashboard.firstColor,
                                    fontFamily: 'Sifonn'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Data Peminjaman",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: screenWidth * 0.4,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 1,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xff6C4AB6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(left: 30),
                                margin: const EdgeInsets.only(top: 20),
                                child: Consumer<PeminjamanProvider>(
                                  builder: (context, peminjamanData, child) {
                                    return Text(
                                      (peminjamanData.dipinjam).toString(),
                                      style: const TextStyle(
                                          fontSize: 80,
                                          color: MyDashboard.firstColor,
                                          fontFamily: 'BebasNeue'),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(left: 30),
                                child: const Text(
                                  "Dipinjam",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: MyDashboard.firstColor,
                                      fontFamily: 'Sifonn'),
                                ),
                              )
                            ]),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xff8D72E1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(left: 30),
                              margin: const EdgeInsets.only(top: 20),
                              child: Consumer<PeminjamanProvider>(
                                builder: (context, peminjamanData, child) {
                                  return Text(
                                    (peminjamanData.dikembalikan).toString(),
                                    style: const TextStyle(
                                        fontSize: 80,
                                        color: MyDashboard.firstColor,
                                        fontFamily: 'BebasNeue'),
                                  );
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(left: 30),
                              child: const Text(
                                "Dikembalikan",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: MyDashboard.firstColor,
                                    fontFamily: 'Sifonn'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   height: 150,
                //   margin: const EdgeInsets.only(top: 20),
                //   width: screenWidth,
                //   decoration: BoxDecoration(
                //     color: const Color(0xff0081B4),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
