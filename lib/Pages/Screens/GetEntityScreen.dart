import 'package:flutter/cupertino.dart';
import 'package:healthy_app/Pages/AddPianoAlimentarePage.dart';
import 'package:healthy_app/Pages/AddSchedaPalestraPage.dart';
import 'package:healthy_app/Pages/GetAllenamentiPage.dart';
import 'package:healthy_app/Pages/GetPianiAlimentari.dart';
import 'package:healthy_app/Pages/GetSchedePalestraPage.dart';

import '../../Utils/Constants.dart';
import '../Background.dart';
import '../Widgets/RoundedButton.dart';

class GetEntityScreen extends StatelessWidget {
  const GetEntityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      key: GlobalKey(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RoundedButton(
              text: "Lista Schede Palestra",
              press: () {
                Constants.redirectTo(context, GetSchedePalestraPage());
              }, key: GlobalKey(),
            ),
            RoundedButton(
              text: "Lista Piani Alimentari",
              press: () {
                Constants.redirectTo(context, GetPianiAlimentari());
              }, key: GlobalKey(),
            ),
            RoundedButton(
              text: "Lista Allenamenti",
              press: () {
                Constants.redirectTo(context, GetAllenamentiPage());
              }, key: GlobalKey(),
            ),
          ],
        ),
      ),
    );
  }
}
