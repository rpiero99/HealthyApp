import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../../Utils/Constants.dart';

Widget makeInput(
    {context,
    label,
    obscureText = false,
    isDate = false,
    TextEditingController? controller,
    isNumber = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 5,
      ),
      TextField(
          readOnly: isDate,
          controller: controller,
          obscureText: obscureText,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          inputFormatters: isNumber ? <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ] : null,
          decoration: InputDecoration(
            hintText: label,
            filled: true,
            icon: isDate ? const Icon(Icons.calendar_today_outlined) : null,
            fillColor: Constants.backgroundButtonColor,
            contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(25.7),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(25.7),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!)),
          ),
          onTap: () async {
            if (isDate) {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101));
              if(pickedDate!=null) {
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
               // var formate1 = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                controller?.text = formattedDate;
              }

            }
          }),
      const SizedBox(
        height: 30,
      )
    ],
  );
}
