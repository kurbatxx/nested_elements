import 'package:flutter/material.dart';
import 'package:izb_ui/widget/custom_expansion_tile.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          CustomExspansionWidget(
            nested: true,
            title: Text('Text'),
            subtitle: Text('Text 1'),
            trailing: Text('-------'),
            children: [
              CustomExspansionWidget(
                nested: true,
              ),
              CustomExspansionWidget(nested: false)
            ],
          ),
        ],
      ),
    );
  }
}
