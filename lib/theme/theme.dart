import 'package:flutter/material.dart';

InputDecoration crInputDec(String hint, bool isLoading) {
  return InputDecoration(
    hintText: hint,
    contentPadding: const EdgeInsetsDirectional.all(10),
    border: const OutlineInputBorder(
      borderSide: BorderSide(width: 3, color: Colors.greenAccent),
    ),
    isCollapsed: true,
    suffix: isLoading
        ? const SizedBox.square(
            dimension: 16.0,
            child: CircularProgressIndicator(),
          )
        : null,
  );
}

Transform crOffset(Widget child) {
  return Transform.translate(
    offset: const Offset(-48 - 4 + 24, 0),
    child: child,
  );
}
