import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Controller/HealthyAppController.dart';
import '../Model/AnagraficaUtente.dart';
import '../Model/Utente.dart';
import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/InputWidget.dart';

class ViewAnagraficaPage extends StatelessWidget {
  ViewAnagraficaPage({Key? key}) : super(key: key);

  static HealthyAppController c = HealthyAppController.instance;

  AnagraficaUtente? anagraficaSelected;
  Utente?  utenteSelected;

  TextEditingController altezaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController dataNascitaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController sessoController = TextEditingController();

  String? getCurrentIdUser() {
    return c.gestoreAuth.firebaseAuth.currentUser?.uid;
  }

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
      body: SizedBox(
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
                      "Crea Scheda Palestra",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Constants.text,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      makeInput(
                          label: "Nome..",
                          obscureText: false,
                          controller: nomeController),
                      makeInput(
                          label: "Email..",
                          obscureText: false,
                          controller: emailController),
                      makeInput(
                        label: "Data di nascita..",
                        obscureText: false,
                        controller: dataNascitaController,
                        isDate: true,
                        context: context,
                      ),
                      makeInput(
                        label: "Sesso..",
                        obscureText: false,
                        controller: sessoController,
                        context: context,
                      ),
                      makeInput(
                        label: "Altezza (in cm)..",
                        obscureText: false,
                        controller: altezaController,
                        context: context,
                      ),
                      makeInput(
                        label: "Peso (in kg)..",
                        obscureText: false,
                        controller: pesoController,
                        context: context,
                      ),
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
                        if (nomeController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            DateTime.parse(dataNascitaController.text).isBefore(DateTime.now()) &&
                            altezaController.text.isNotEmpty &&
                            pesoController.text.isNotEmpty &&
                            sessoController.text.isNotEmpty) {

                          anagraficaSelected = c.createAnagraficaUtente(int.parse(altezaController.text), DateTime.parse(dataNascitaController.text), nomeController.text, double.parse(pesoController.text), sessoController.text);
                          utenteSelected = c.createUtente(anagraficaSelected!, emailController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                              Constants.createSnackBar(
                                  'Utente creato correttamente.',
                                  Constants.successSnackBar));
                          Constants.redirectTo(context, HomePage());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              Constants.createSnackBar('Inserire tutti i dati o controllare che la data di nascita non sia futura.',
                                  Constants.errorSnackBar));
                        }
                      },
                      color: Constants.backgroundColorLoginButton,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      child: const Text(
                        "Crea Utente",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Constants.textButtonColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}