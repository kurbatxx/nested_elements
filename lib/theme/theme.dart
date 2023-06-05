import 'package:flutter/material.dart';

InputDecoration crInputDec(String hint) {
  return InputDecoration(
    hintText: hint,
    contentPadding: const EdgeInsetsDirectional.all(10),
    border: const OutlineInputBorder(
      borderSide: BorderSide(width: 3, color: Colors.greenAccent),
    ),
    isCollapsed: true,
  );
}

Transform crOffset(Widget child) {
  return Transform.translate(
    offset: const Offset(-48 - 4 + 24, 0),
    child: child,
  );
}
