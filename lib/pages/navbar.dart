import 'package:flutter/material.dart';
import 'package:perpustakaan/main.dart';
import 'package:perpustakaan/pages/buku_pages.dart';
import 'package:perpustakaan/pages/buku_paginate_pages.dart';
import 'package:perpustakaan/pages/film_page.dart';
import 'package:perpustakaan/pages/kategori_buku_pages.dart';
import 'package:perpustakaan/pages/kategori_film_pagaes.dart';
import 'package:perpustakaan/pages/member_pages.dart';
import 'package:perpustakaan/pages/peminjaman_pages.dart';
import 'package:perpustakaan/pages/peminjaman_paginate_pages.dart';
import 'package:perpustakaan/providers/api_provider.dart';
import 'package:perpustakaan/providers/data_provider.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<ApiProvider>(
        builder: (context, dataProvider, child) {
          return ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(dataProvider.name),
                accountEmail: Text(dataProvider.email),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Member'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyMember(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.movie_creation_rounded),
                title: const Text('Film'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyFilm(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('Buku'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyBookPage(),
                    ),
                  );
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.menu_book),
              //   title: const Text('Buku'),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const MyBook(),
              //       ),
              //     );
              //   },
              // ),
              ExpansionTile(
                leading: const Icon(Icons.category_rounded),
                title: const Text("Kategori"),
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: ListTile(
                      title: Row(children: [
                        Container(
                          margin: const EdgeInsets.only(right: 30),
                          child: const Text("\u2022"),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 30),
                          child: const Text("Kategori Film"),
                        ),
                      ]),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MyCategoryFilm(),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: ListTile(
                      title: Row(children: [
                        Container(
                          margin: const EdgeInsets.only(right: 30),
                          child: const Text("\u2022"),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 30),
                          child: const Text("Kategori Buku"),
                        ),
                      ]),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MyCategoryBook(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.library_books_rounded),
                title: const Text('Peminjaman'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyPeminjamanPage(),
                    ),
                  );
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.library_books_rounded),
              //   title: const Text('Peminjaman'),
              //   onTap: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => const PeminjamanPage(),
              //       ),
              //     );
              //   },
              // ),
              Consumer<ApiProvider>(
                builder: (context, dataProvider, child) => ListTile(
                  title: const Text('Logout'),
                  leading: const Icon(Icons.exit_to_app),
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    await Provider.of<ApiProvider>(context, listen: false)
                        .logout(context);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
