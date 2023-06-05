import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/api/api.dart';
import 'package:izb_ui/enum/menu.dart';
import 'package:izb_ui/enum/node_type.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/provider/menu_provider.dart';
import 'package:izb_ui/provider/mode_provider.dart';

class HorizontalOption extends HookConsumerWidget {
  const HorizontalOption(this.node, {super.key});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menu = ref.watch(menuProvider(node));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        switch (menu) {
          Menu.hide => FilledButton(
              onPressed: () {
                ref.read(menuProvider(node).notifier).show();
              },
              child: const Text('option'),
            ),
          Menu.show => Row(
              children: [
                if (!node.nested)
                  FilledButton(
                    onPressed: () {
                      ref
                          .read(modeProvider(node).notifier)
                          .setCreate(type: NodeType.street);
                    },
                    child: const Text('Добавить улицу'),
                  ),
                FilledButton(
                  onPressed: () {
                    ref
                        .read(modeProvider(node).notifier)
                        .setCreate(type: NodeType.node);
                  },
                  child: const Text('Создать подкаталог'),
                ),
                FilledButton(
                  onPressed: () {
                    ref.read(modeProvider(node).notifier).setEdit();
                  },
                  child: const Text('Редактировать'),
                ),
                if (!node.nested)
                  FilledButton(
                    onPressed: () {
                      ref.read(apiProvider).dropElement(node);
                    },
                    child: const Text('Удалить'),
                  ),
                FilledButton(
                  onPressed: () {
                    ref.read(menuProvider(node).notifier).hide();
                  },
                  child: const Text('Скрыть'),
                )
              ],
            ),
        }
      ],
    );
  }
}
