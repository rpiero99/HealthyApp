import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Controller/HealthyAppController.dart';
import '../Model/AnagraficaUtente.dart';
import '../Model/CategoriaPasto.dart';
import '../Model/Utente.dart';
import '../Utils/Constants.dart';
import 'HomePage.dart';
import 'Widgets/InputWidget.dart';

class AddPastoGiornaliero extends StatelessWidget {
  AddPastoGiornaliero({Key? key}) : super(key: key);

  AnagraficaUtente? anagraficaNew;
  Utente? utenteNew;

  TextEditingController calorieController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController descrizionePastoController = TextEditingController();
  TextEditingController nomePastoController = TextEditingController();
  TextEditingController quantitaController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  String? categoriaComboItem = 'Categoria pasto..';

  String? getCurrentIdUser() {
    return Constants.controller.gestoreAuth.firebaseAuth.currentUser?.uid;
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
        child: SingleChildScrollView(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Column(
                    children: const [
                      Text(
                        "Crea Pasto",
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
                            controller: nomePastoController),

                        makeInput(
                            label: "Descrizione..",
                            obscureText: false,
                            controller: descrizionePastoController),
                        makeInput(
                          label: "Quantità..",
                          obscureText: false,
                          controller: quantitaController,
                          context: context,
                        ),
                        StatefulBuilder(
                          builder: (BuildContext context, StateSetter dropDownState){
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child:
                              Container(
                                height: 40,
                                width: 270,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(style: BorderStyle.solid, width: 0.80),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    items: Constants.categoriePastoString()
                                        .map((String item) => DropdownMenuItem<String>(
                                        child: Text(item), value: item))
                                        .toList(),
                                    onChanged: (value) {
                                      dropDownState(() {
                                        categoriaComboItem = value as String?;
                                      });
                                    },
                                    value: categoriaComboItem,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        makeInput(
                          label: "Tipo..",
                          obscureText: false,
                          controller: typeController,
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
                          if (nomePastoController.text.isNotEmpty &&
                              descrizionePastoController.text.isNotEmpty &&
                              quantitaController.text.isNotEmpty &&
                              typeController.text.isNotEmpty &&
                              calorieController.text.isNotEmpty &&
                              categoriaComboItem != 'Categoria pasto..') {
                            Constants.controller.createPastoOfDay(Constants.getCategoriaFromString(categoriaComboItem!),
                                int.parse(calorieController.text),
                                descrizionePastoController.text,
                                nomePastoController.text,
                                int.parse(quantitaController.text),
                                typeController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                                Constants.createSnackBar(
                                    'Pasto aggiunto correttamente.',
                                    Constants.successSnackBar));
                            Constants.redirectTo(context, HomePage());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                Constants.createSnackBar('Inserire tutti i dati.',
                                    Constants.errorSnackBar));
                          }
                          categoriaComboItem = CategoriaPasto.values[0].toString().split('.').last;
                          Navigator.pop(context);
                        },
                        color: Constants.backgroundColorLoginButton,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        child: const Text(
                          "Aggiungi Pasto",
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
        )
      ),
    );
  }
}