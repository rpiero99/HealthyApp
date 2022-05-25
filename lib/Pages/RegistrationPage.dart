import 'package:flutter/material.dart';
import 'package:healthy_app/Pages/LoginPage.dart';

import '../Controller/HealthyAppController.dart';
import '../Utils/Constants.dart';
import 'Widgets/InputWidget.dart';

class RegistrationPage extends StatelessWidget {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
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
        ),
        body: SafeArea(
          child: Container(
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
                          "Registrati",
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
                          "Prova questa fantastica app!",
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
                      child: Column(children: [
                        makeInput(label: "Email", controller: emailController),
                        makeInput(
                            label: "Password",
                            obscureText: true,
                            controller: passwordController)
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            if(emailController.text.trim()!="" && passwordController.text.trim()!="" &&
                                  passwordController.text.trim().length>=6){
                              Constants.controller.registrazione(emailController.text.trim(),
                                  passwordController.text.trim());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginPage();
                                  },
                                ),
                              );
                            }else{
                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context).showSnackBar(Constants.createSnackBar('Nome utente e/o password non corretti (la password deve contenere almeno 6 caratteri', Constants.errorSnackBar));
                            }
                          },
                          color: Constants.backgroundColorLoginButton,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          child: const Text(
                            "Registrazione",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Constants.textButtonColor),
                          ),
                        ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text(
                        "Sei già registrato? ",
                        style: TextStyle(
                          color: Constants.text,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Constants.text,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginPage();
                              },
                            ),
                          );
                        },
                      ),
                    ])
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
