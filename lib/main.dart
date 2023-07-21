import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/widget/nest_list_widget/component/rotate_button_icon.dart';
import 'package:izb_ui/widget/nest_list_widget/nest_list_widget.dart';

void main() {
  runApp(
    const ProviderScope(child: MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Выберите элемент'),
          actions: const [],
        ),
        body: const NestListWidget(parrentId: 0),
        //body: RotateButtonIcon(isOpen: false, id: 0),
      ),
    );
  }
}
