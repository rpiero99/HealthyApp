import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/Pages/MainPage.dart';

import '../Controller/HealthyAppController.dart';
import '../Model/AnagraficaUtente.dart';
import '../Model/Utente.dart';
import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/InputWidget.dart';

class EditAnagraficaPage extends StatefulWidget {
  @override
  _EditAnagraficaPage createState() => _EditAnagraficaPage();

}

class _EditAnagraficaPage extends State<EditAnagraficaPage> {
  TextEditingController altezzaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController dataNascitaController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController sessoController = TextEditingController();
  Utente? utenteSelected;

  Future<Utente?> getCurrentUser() async{
    return await Constants.controller.getUtenti().then((value) =>
      value.where((element) =>
      element.email== Constants.controller.gestoreAuth.firebaseAuth.currentUser!.email!).first);
    }

  @override
  void initState() {
    getCurrentUser().then((val) {
      setState(() {
        utenteSelected = val;
      });
    });
    super.initState();
  }

  void setFields(){
    altezzaController.text = utenteSelected!.anagraficaUtente!.altezzaUtente.toString();
    nomeController.text = utenteSelected!.anagraficaUtente!.nomeUtente!;
    dataNascitaController.text =
        utenteSelected!.anagraficaUtente!.dataNascitaUtente.toString();
    pesoController.text = utenteSelected!.anagraficaUtente!.pesoUtente.toString();
    sessoController.text = utenteSelected!.anagraficaUtente!.sessoUtente!;
  }

  @override
  Widget build(BuildContext context) {
    if(utenteSelected!=null){
      setFields();
      return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Constants.backgroundColor,
/*          appBar: AppBar(
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
          ),*/
          body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Modifica scheda anagrafica",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Constants.text,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          makeInput(
                              obscureText: false,
                              controller: nomeController),
                          makeInput(
                            obscureText: false,
                            controller: dataNascitaController,
                            isDate: true,
                            context: context,
                          ),
                          makeInput(
                            obscureText: false,
                            controller: sessoController,
                            context: context,
                          ),
                          makeInput(
                            obscureText: false,
                            controller: altezzaController,
                            context: context,
                            isNumber: true,
                          ),
                          makeInput(
                            obscureText: false,
                            controller: pesoController,
                            context: context,
                            isNumber: true,
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
                                  DateTime.parse(
                                      dataNascitaController.text)
                                      .isBefore(DateTime.now()) &&
                                  altezzaController.text.isNotEmpty &&
                                  pesoController.text.isNotEmpty &&
                                  sessoController.text.isNotEmpty) {
                                utenteSelected!.anagraficaUtente
                                    ?.nomeUtente = nomeController.text;
                                utenteSelected!.anagraficaUtente
                                    ?.dataNascitaUtente =
                                    DateTime.parse(
                                        dataNascitaController.text);
                                utenteSelected!.anagraficaUtente
                                    ?.altezzaUtente =
                                    int.parse(altezzaController.text);
                                utenteSelected!.anagraficaUtente
                                    ?.pesoUtente =
                                    double.parse(pesoController.text);
                                utenteSelected!.anagraficaUtente
                                    ?.sessoUtente = sessoController.text;

                                Constants.controller.updateAnagraficaUtente(
                                    utenteSelected!.anagraficaUtente!);
                                Constants.controller
                                    .updateUtente(utenteSelected!);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    Constants.createSnackBar(
                                        'Utente modificato correttamente.',
                                        Constants.successSnackBar));
                                Constants.redirectTo(context, MainPage());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    Constants.createSnackBar(
                                        'Inserire tutti i dati o controllare che la data di nascita non sia futura.',
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
                        )
                    )
                  ],
                ),
              )
          )
      );
    }
    else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
