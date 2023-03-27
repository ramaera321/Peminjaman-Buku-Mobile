import 'package:flutter/material.dart';
import 'package:perpustakaan/main.dart';
import 'package:perpustakaan/pages/buku_pages.dart';
import 'package:perpustakaan/pages/film_page.dart';
import 'package:perpustakaan/pages/kategori_buku_pages.dart';
import 'package:perpustakaan/pages/kategori_film_pagaes.dart';
import 'package:perpustakaan/pages/member_pages.dart';
import 'package:perpustakaan/pages/peminjaman_pages.dart';
import 'package:perpustakaan/providers/api_provider.dart';
import 'package:perpustakaan/providers/data_provider.dart';
import 'package:provider/provider.dart';

class NavBarVisitor extends StatelessWidget {
  const NavBarVisitor({super.key});

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
