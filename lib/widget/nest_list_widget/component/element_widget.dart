import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/enum/mode.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/provider/mode_provider.dart';
import 'package:izb_ui/widget/nest_list_widget/component/horizontal_option.dart';

class ElementWidget extends HookConsumerWidget {
  const ElementWidget(this.node, {super.key});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeProvider(node));
    final textController = useTextEditingController(text: node.nodeName);

    final Widget name = switch (mode) {
      Mode.noEdit => Text(node.nodeName),
      Mode.edit => TextFormField(
          controller: textController,
          autofocus: true,
        ),
      _ => const SizedBox(),
    };

    if (node.nested) {
      return ExpansionTile(
        title: Transform.translate(
          offset: const Offset(-48 - 4 + 24, 0),
          child: name,
        ),
        tilePadding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
        leading: const Icon(
          Icons.keyboard_arrow_right_outlined,
        ),
        trailing: HorizontalOption(node),
      );
    } else {
      return ListTile(
        contentPadding: const EdgeInsetsDirectional.only(start: 24 + 8, end: 8),
        title: name,
        trailing: HorizontalOption(node),
      );
    }
  }
}
