import 'package:firebase_auth/firebase_auth.dart';
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

  final FirebaseAuth auth = FirebaseAuth.instance;
  AnagraficaUtente? anagraficaSelected;
  Utente?  utenteSelected;

  TextEditingController altezaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController dataNascitaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController sessoController = TextEditingController();

  Future<void> getCurrentUser() async {
    final User? user = auth.currentUser;
    String? uid = user?.uid;
    utenteSelected = await Constants.controller.getUtenteById(uid!);
    anagraficaSelected = utenteSelected?.anagraficaUtente;
/*    nomeController.text = anagraficaSelected!.nomeUtente!;
    altezaController.text = anagraficaSelected!.altezzaUtente.toString();
    dataNascitaController.text = anagraficaSelected!.dataNascitaUtente.toString();
    emailController.text = utenteSelected!.email!;
    sessoController.text = anagraficaSelected!.sessoUtente!;
    pesoController.text = anagraficaSelected!.pesoUtente.toString();*/
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
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
                      "Modifica scheda anagrafica",
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
                          label: anagraficaSelected?.nomeUtente,
                          obscureText: false,
                          controller: nomeController),
                      makeInput(
                          label: utenteSelected?.email,
                          obscureText: false,
                          controller: emailController),
                      makeInput(
                        label: anagraficaSelected?.dataNascitaUtente.toString(),
                        obscureText: false,
                        controller: dataNascitaController,
                        isDate: true,
                        context: context,
                      ),
                      makeInput(
                        label: anagraficaSelected?.sessoUtente,
                        obscureText: false,
                        controller: sessoController,
                        context: context,
                      ),
                      makeInput(
                        label: anagraficaSelected?.altezzaUtente.toString(),
                        obscureText: false,
                        controller: altezaController,
                        context: context,
                      ),
                      makeInput(
                        label: anagraficaSelected?.pesoUtente.toString(),
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
                       ),
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

                          anagraficaSelected?.nomeUtente = nomeController.text;
                          anagraficaSelected?.dataNascitaUtente = DateTime.parse(dataNascitaController.text);
                          anagraficaSelected?.altezzaUtente = int.parse(altezaController.text);
                          anagraficaSelected?.pesoUtente = int.parse(pesoController.text);
                          anagraficaSelected?.sessoUtente = sessoController.text;

                          Constants.controller.updateAnagraficaUtente(anagraficaSelected!);
                          utenteSelected?.anagraficaUtente = anagraficaSelected;
                          utenteSelected?.email = emailController.text;
                          Constants.controller.updateUtente(utenteSelected!);

                          ScaffoldMessenger.of(context).showSnackBar(
                              Constants.createSnackBar(
                                  'Utente modificato correttamente.',
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
                        "Modifica Utente",
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