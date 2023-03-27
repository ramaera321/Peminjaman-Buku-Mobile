import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/global/my_global.dart';
import 'package:perpustakaan/pages/dashboard.dart';
import 'package:perpustakaan/pages/login_page.dart';
import 'package:perpustakaan/pages/register_page.dart';
import 'package:perpustakaan/providers/api_provider.dart';
import 'package:perpustakaan/providers/buku_provider.dart';
import 'package:perpustakaan/providers/data_provider.dart';
import 'package:perpustakaan/providers/peminjaman_provider.dart';
import 'package:perpustakaan/providers/screen_change_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ApiProvider(),
        ),
        ChangeNotifierProxyProvider<ApiProvider, ScreenChangeProvider>(
          create: (context) => ScreenChangeProvider(),
          update: (context, api, screen) => screen!
            ..getMessage(
              api.nameError,
              api.usernameError,
              api.emailError,
              api.passwordError,
              api.confirmPasswordError,
            ),
        ),
        ChangeNotifierProxyProvider<ApiProvider, BookProvider>(
          create: (context) => BookProvider(),
          update: (context, api, book) => book!..getToken(api.idToken),
        ),
        ChangeNotifierProxyProvider2<ApiProvider, BookProvider,
            PeminjamanProvider>(
          create: (context) => PeminjamanProvider(),
          update: (context, api, buku, peminjaman) => peminjaman!
            ..getToken(api.idToken, buku.buku, api.dataMember, api.userId,
                api.roleUser),
        ),
        ChangeNotifierProvider(
          create: (context) => DataProvider(),
        ),
      ],
      child: Consumer<ApiProvider>(
        builder: (context, dataProvider, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home: EasySplashScreen(
              logo: Image.asset('assets/images/library_image.png', height: 150),
              title: const Text(
                "Aplikasi Perpustakaan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              backgroundColor: GLobalVar.secondColor,
              showLoader: true,
              navigator:
                  dataProvider.isAuth ? const MyDashboard() : const MyHome(),
              durationInSeconds: 7,
            )),
      ),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  static const Color firstColor = Color(0xffFFFDE8);

  static const Color secondColor = Color(0xffF7E0A3);

  static const Color thirdColor = Color(0xffF09C67);

  static const Color fourthColor = Color(0xff4C8492);

  static const Color whiteColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: secondColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 120),
              padding: const EdgeInsets.only(top: 70),
              width: screenWidth,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                // borderRadius:
                //     BorderRadius.vertical(bottom: Radius.elliptical(180, 100)),
                color: Colors.white,
              ),
              child: Image.asset(
                'assets/images/library_image.png',
                height: 250,
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "BaseCamp Perpus",
                        style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: fourthColor,
                            fontFamily: 'BebasNeue'),
                      ),
                      RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                            style: TextStyle(
                                fontSize: 19,
                                fontStyle: FontStyle.italic,
                                color: fourthColor,
                                fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    "Jelajahi lebih jauh dunia ini dengan membaca buku !!",
                              ),
                            ]),
                      ),
                    ],
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: SizedBox(
                width: 330,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: thirdColor,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: SizedBox(
                width: 330,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: fourthColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Registrasi",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
