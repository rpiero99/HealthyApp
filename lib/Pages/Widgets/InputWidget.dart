import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Utils/Constants.dart';

Widget makeInput(
    {label,
    obscureText = false,
    TextEditingController? controller,
    isDate = false,
    context}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 5,
      ),
      TextField(
        controller: controller,
        readOnly: isDate,
        //set it true, so that user will not able to edit text
        onTap: () async {
          if (isDate) {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
                firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2101)
            );
            if (pickedDate != null) {
              String formattedDate = DateFormat('yyyy-MM-dd').format(
                  pickedDate);
              controller?.text =
                  formattedDate;
            }
          }
        },
        obscureText: obscureText,
        decoration: InputDecoration(
          icon: isDate ? const Icon(Icons.calendar_today) : null,
          hintText: label,
          filled: true,
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
      ),
      const SizedBox(
        height: 30,
      )
    ],
  );
}
