import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/api/api_client.dart';
import 'package:perpustakaan/main.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:perpustakaan/models/user_model.dart';
import 'package:perpustakaan/pages/dashboard.dart';
import 'package:perpustakaan/pages/register_page.dart';
import 'package:perpustakaan/providers/api_provider.dart';
import 'package:perpustakaan/providers/data_provider.dart';
import 'package:perpustakaan/providers/screen_change_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

RoundedLoadingButtonController _loadingButton =
    RoundedLoadingButtonController();

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static const Color firstColor = Color(0xffFFFDE8);

  static const Color secondColor = Color(0xffF7E0A3);

  static const Color thirdColor = Color(0xffF09C67);

  static const Color fourthColor = Color(0xff4C8492);

  static const Color whiteColor = Colors.white;

  static final TextEditingController _usernameController =
      TextEditingController();
  static final TextEditingController _passwordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: secondColor,
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.topLeft,
              child: const Text(
                'Welcome Back',
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 38,
                  color: fourthColor,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(top: 30),
              width: screenWidth,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                // borderRadius:
                //     BorderRadius.vertical(bottom: Radius.elliptical(180, 100)),
                color: Colors.white,
              ),
              child: Image.asset(
                'assets/images/login.png',
                height: 120,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
              padding: const EdgeInsets.symmetric(
                vertical: 50,
                horizontal: 30,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              // color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Username",
                        hintText: "Enter your username",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<ScreenChangeProvider>(builder: (
                    context,
                    passwordProvider,
                    child,
                  ) {
                    return Container(
                      height: 45,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: passwordProvider.password,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Password",
                          hintText: "Enter your password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              Provider.of<ScreenChangeProvider>(context,
                                      listen: false)
                                  .changePassword();
                            },
                            icon: Icon(
                              passwordProvider.password
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<ApiProvider>(
                    builder: (
                      context,
                      apiProvider,
                      child,
                    ) {
                      return Container(
                        width: screenWidth,
                        height: 45,
                        child: Consumer<ApiProvider>(
                          builder: (
                            context,
                            dataProvider,
                            child,
                          ) {
                            return RoundedLoadingButton(
                              controller: _loadingButton,
                              onPressed: dataProvider.isLoading
                                  ? null
                                  : () async {
                                      await Provider.of<ApiProvider>(context,
                                              listen: false)
                                          .login(
                                        _usernameController.text,
                                        _passwordController.text,
                                      );
                                      _loadingButton.success();
                                      Timer(const Duration(seconds: 1), () {
                                        _loadingButton.reset();
                                      });
                                      if (dataProvider.isSuccess) {
                                        Timer(const Duration(seconds: 1), () {
                                          _usernameController.clear();
                                          _passwordController.clear();

                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyDashboard(),
                                            ),
                                          );
                                        });
                                      }
                                    },
                              successIcon: dataProvider.isSuccess
                                  ? Icons.check
                                  : Icons.close,
                              successColor: dataProvider.isSuccess
                                  ? Colors.green
                                  : Colors.red,
                              color: fourthColor,
                              child: const Text("Login"),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  const Text(
                    "Belum punya akun ?",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                      onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            ),
                          },
                      child: const Text("Registrasi akun")),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
