// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hinttext;

  TextEditingController controller = TextEditingController();
  MyTextField({super.key, required this.hinttext, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          hintText: hinttext,
        ),
      ),
    );
  }
}
