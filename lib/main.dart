import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/widget/nest_list_widget/nest_list_widget.dart';
import 'package:izb_ui/widget/t_widget.dart';

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
      routes: {
        '/test': (context) => MyWidget(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Выберите элемент'),
          actions: [
            Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/test");
                  },
                  child: const Text(''),
                );
              }
            )
          ],
        ),
        body: const NestListWidget(pId: 0),
      ),
    );
  }
}
