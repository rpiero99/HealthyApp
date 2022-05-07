import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Utils/Constants.dart';

Widget makeBottomAppBar(){

  return SizedBox(
    height: 55.0,
    child: BottomAppBar(
      //
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(
      //     topLeft: Radius.circular(25),
      //     topRight: Radius.circular(25),
      //     bottomRight: Radius.circular(25),
      //     bottomLeft: Radius.circular(25),
      //   ),
      // ),
      color: Constants.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.blur_on, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.hotel, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_box, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
    ),
  );
}