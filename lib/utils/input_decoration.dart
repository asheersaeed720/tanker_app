import 'package:flutter/material.dart';

InputDecoration buildTextFieldInputDecoration(
  context, {
  required String labelTxt,
  Widget? preffixIcon,
}) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade400,
        width: 1.0,
      ),
    ),
    labelText: labelTxt,
    labelStyle: const TextStyle(color: Colors.black87),
    isDense: true,
    prefixIcon: preffixIcon,
  );
  // return InputDecoration(
  //   filled: true,
  //   fillColor: Colors.white,
  //   border: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(6.0),
  //     borderSide: BorderSide.none,
  //   ),
  //   enabledBorder: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(6.0),
  //     borderSide: BorderSide.none,
  //   ),
  //   hintText: hintTxt,
  //   isDense: true,
  //   prefixIcon: preffixIcon ?? null,
  // );
}

InputDecoration buildPasswordInputDecoration(
  context, {
  required String labelTxt,
  required Widget suffixIcon,
}) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade400,
        width: 1.0,
      ),
    ),
    labelText: labelTxt,
    isDense: true,
    labelStyle: const TextStyle(color: Colors.black87),
    prefixIcon: const Icon(Icons.lock),
    suffixIcon: suffixIcon,
  );
  // return InputDecoration(
  //   filled: true,
  //   fillColor: Colors.white,
  //   border: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(6.0),
  //     borderSide: BorderSide.none,
  //   ),
  //   enabledBorder: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(6.0),
  //     borderSide: BorderSide.none,
  //   ),
  //   hintText: hintTxt,
  //   isDense: true,
  //   prefixIcon: const Icon(Icons.lock),
  //   suffixIcon: suffixIcon,
  // );
}
