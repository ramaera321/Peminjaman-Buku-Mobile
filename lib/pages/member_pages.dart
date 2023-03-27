import 'package:flutter/material.dart';
import 'package:perpustakaan/global/my_global.dart';
import 'package:perpustakaan/pages/dashboard.dart';
import 'package:perpustakaan/providers/api_provider.dart';
import 'package:provider/provider.dart';

class MyMember extends StatefulWidget {
  const MyMember({super.key});

  @override
  State<MyMember> createState() => _MyMemberState();
}

class _MyMemberState extends State<MyMember> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ApiProvider>(context, listen: false).getMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyDashboard()));
            },
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                alignment: Alignment.topLeft,
                child: const Text(
                  "List Member",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sifonn'),
                ),
              ),
              Container(
                height: screenHeight * 0.705,
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Consumer<ApiProvider>(
                    builder: (context, dataProvider, child) {
                      return Container(
                        child: Column(
                          children: dataProvider.dataMember.map((member) {
                            return Card(
                              color: Colors.white,
                              child: ListTile(
                                title: Text(member.name),
                                subtitle: Text(member.email),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Consumer<ApiProvider>(
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
                                              await Provider.of<ApiProvider>(
                                                      context,
                                                      listen: false)
                                                  .getMembers(e.url);
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
