import 'dart:async';

import 'package:flutter/material.dart';
import 'package:perpustakaan/main.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:perpustakaan/pages/login_page.dart';
import 'package:perpustakaan/providers/api_provider.dart';
import 'package:perpustakaan/providers/screen_change_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

RoundedLoadingButtonController _loadingButton =
    RoundedLoadingButtonController();

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  static const Color firstColor = Color(0xffFFFDE8);

  static const Color secondColor = Color(0xffF7E0A3);

  static const Color thirdColor = Color(0xffF09C67);

  static const Color fourthColor = Color(0xff4C8492);

  static const Color whiteColor = Colors.white;

  static final TextEditingController _nameController = TextEditingController();
  static final TextEditingController _usernameController =
      TextEditingController();
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _passwordController =
      TextEditingController();
  static final TextEditingController _confirmPasswordController =
      TextEditingController();

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                'Create New Account',
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
                'assets/images/register.png',
                height: 120,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 30,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              // color: Colors.white,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Consumer<ScreenChangeProvider>(
                      builder: (context, dataProvider, child) {
                        return TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Name",
                            hintText: "Enter your name",
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            if (dataProvider.nameError != 'kosong') {
                              return dataProvider.nameError;
                            }
                            return null;
                          },
                          onChanged: (value) {},
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<ScreenChangeProvider>(
                      builder: (
                        context,
                        dataProvider,
                        child,
                      ) {
                        return TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username",
                            hintText: "Enter your username",
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            if (dataProvider.usernameError != 'kosong') {
                              return dataProvider.usernameError;
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<ScreenChangeProvider>(
                      builder: (
                        context,
                        dataProvider,
                        child,
                      ) {
                        return TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email",
                            hintText: "Enter your Email",
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (dataProvider.emailError != 'kosong') {
                              return dataProvider.emailError;
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<ScreenChangeProvider>(builder: (
                      context,
                      passwordProvider,
                      child,
                    ) {
                      return TextFormField(
                        controller: _passwordController,
                        obscureText: passwordProvider.password,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Password",
                          hintText: "Enter your password",
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (passwordProvider.passwordError != 'kosong') {
                            return passwordProvider.passwordError;
                          }
                          return null;
                        },
                      );
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<ScreenChangeProvider>(builder: (
                      context,
                      passwordProvider,
                      child,
                    ) {
                      return TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: passwordProvider.consfirmPassword,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Confirm Password",
                          hintText: "Enter your confirm password",
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          suffixIcon: IconButton(
                            onPressed: () {
                              Provider.of<ScreenChangeProvider>(context,
                                      listen: false)
                                  .changeConfirmPassword();
                            },
                            icon: Icon(
                              passwordProvider.consfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your confirm password';
                          }
                          if (passwordProvider.confirmPasswordError !=
                              'kosong') {
                            return passwordProvider.confirmPasswordError;
                          }
                          return null;
                        },
                      );
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<ApiProvider>(
                      builder: (context, dataProvider, child) {
                        return RoundedLoadingButton(
                          controller: _loadingButton,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                            }
                            await Provider.of<ApiProvider>(context,
                                    listen: false)
                                .register(
                              _nameController.text,
                              _usernameController.text,
                              _emailController.text,
                              _passwordController.text,
                              _confirmPasswordController.text,
                            );
                            _loadingButton.success();
                            Timer(const Duration(seconds: 1), () {
                              _loadingButton.reset();
                            });
                            if (dataProvider.isSuccess) {
                              Timer(const Duration(seconds: 1), () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
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
                          child: const Text("Registrasi"),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  const Text(
                    "Sudah punya akun ?",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                      onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            ),
                          },
                      child: const Text("Login aplikasi")),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
