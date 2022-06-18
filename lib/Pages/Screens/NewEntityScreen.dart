import 'package:flutter/cupertino.dart';
import 'package:healthy_app/Pages/AddPianoAlimentarePage.dart';
import 'package:healthy_app/Pages/AddSchedaPalestraPage.dart';

import '../../Utils/Constants.dart';
import '../Background.dart';
import '../Widgets/RoundedButton.dart';

class NewEntityScreen extends StatelessWidget {
  const NewEntityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      key: GlobalKey(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RoundedButton(
              text: "Aggiungi Scheda Palestra",
              press: () {
                Constants.redirectTo(context, const AddSchedaPalestraPage());
              }, key: GlobalKey(),
            ),
            RoundedButton(
              text: "Aggiungi Piano Alimentare",
              press: () {
                Constants.redirectTo(context, AddPianoAlimentarePage());
              }, key: GlobalKey(),
            ),
          ],
        ),
      ),
    );
  }
}
