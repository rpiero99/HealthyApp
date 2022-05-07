import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/Model/Handlers/GestoreAuth.dart';
import 'package:healthy_app/Pages/HomePage.dart';
import 'package:healthy_app/Pages/RegistrationPage.dart';
import 'package:healthy_app/Pages/Widgets/TopAppBar.dart';
import 'package:healthy_app/Utils/Constants.dart';

import '../Controller/HealthyAppController.dart';
import 'Widgets/InputWidget.dart';

class LoginPage extends StatelessWidget {
  static HealthyAppController c = HealthyAppController.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.backgroundColor,
         appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.backgroundColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Constants.text,
              )),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Column(
                      children: const [
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Constants.text,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Welcome back ! Login with your credentials",
                          style: TextStyle(
                            fontSize: 15,
                            color: Constants.text,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          makeInput(
                              label: "Email",
                              obscureText: false,
                              controller: emailController),
                          makeInput(
                              label: "Password",
                              obscureText: true,
                              controller: passwordController),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: const EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: const Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black))),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () async {
                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              if (await c.login(emailController.text.trim(),
                                      passwordController.text.trim()) !=
                                  "signUp") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    Constants.createSnackBar(
                                        'Credenziali errate',
                                        Constants.errorSnackBar));
                              } else {
                               Constants.redirectTo(context, HomePage());
                              }
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                  Constants.createSnackBar(
                                      'Inserire le credenziali.',
                                      Constants.errorSnackBar));
                            }
                          },
                          color: Constants.backgroundColorLoginButton,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Constants.textButtonColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Ma non hai già un account? ",
                          style: TextStyle(
                            color: Constants.text,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          child: const Text(
                            "Registrati",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              color: Constants.text,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return RegistrationPage();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
