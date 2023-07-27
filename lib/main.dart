import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
          centerTitle: true,
          title: const Text('Заполните адреса'),
          actions: const [],
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: NestListWidget(parrentId: 0),
        ),
      ),
    );
  }
}
