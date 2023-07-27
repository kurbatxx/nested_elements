import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/enum/mode.dart';
import 'package:izb_ui/enum/node_type.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/provider/common_provider.dart';
import 'package:izb_ui/provider/loading_state_provider.dart';
import 'package:izb_ui/provider/mode_provider.dart';
import 'package:izb_ui/provider/node_list_provider.dart';
import 'package:izb_ui/provider/open_elements_id_provider.dart';
import 'package:izb_ui/theme/theme.dart';
import 'package:izb_ui/widget/buildings_widget.dart';
import 'package:izb_ui/widget/custom_expansion_tile.dart';
import 'package:izb_ui/widget/nest_list_widget/component/horizontal_option.dart';
import 'package:izb_ui/widget/nest_list_widget/nest_list_widget.dart';

import 'dart:developer' as dev show log;

class ElementWidget extends HookConsumerWidget {
  const ElementWidget(this.node, {super.key});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeProvider(node));
    //final nodeType = ref.watch(nodeTypeProvider);
    final isLoading = ref.watch(loadingStateProvider);

    final textController = useTextEditingController(text: node.nodeName);
    final focus = useFocusNode();

    final hasSubmit = useState(false);

    final createController = useTextEditingController(text: '');

    useEffect(() {
      if (!focus.hasFocus && mode != Mode.edit) {
        textController.text = node.nodeName;
        createController.text = '';
        if (!hasSubmit.value) {
          mode == Mode.noEdit;
        }
      }

      return null;
    });

    final Widget createField = switch (mode) {
      Mode.create => TextFormField(
          controller: createController,
          decoration: crInputDec(
              switch (node.type) {
                NodeType.address => 'Введите название подкаталога',
                NodeType.street => 'Введите название улицы',
                NodeType.building => 'Введите номер дома',
              },
              isLoading),
          onFieldSubmitted: (_) {
            hasSubmit.value = true;
            ref.read(nodeListProvider(node.nodeId).notifier).createNode(
                parrentId: node.nodeId,
                name: createController.text,
                type: node.type);
            ref.read(commonProvider).setDefault();
            hasSubmit.value = false;
            focus.requestFocus();
          },
          autofocus: true,
          focusNode: focus,
        ),
      _ => const SizedBox(),
    };

    final Widget name = switch (mode) {
      Mode.edit => TextFormField(
          decoration: crInputDec('', isLoading),
          controller: textController,
          autofocus: true,
          focusNode: focus,
          onFieldSubmitted: (value) async {
            textController.text = value;

            ref
                .read(nodeListProvider(node.parrentId).notifier)
                .updateNodeName(node, textController.text);
          }),
      _ => Text(node.nodeName),
    };

    dev.log(node.type.name);

    return GestureDetector(
      onTap: () {
        ref.read(commonProvider).setDefault();
      },
      child: CustomExspansionWidget(
        id: node.nodeId,
        nested: node.hasNest || node.deputatUuid != null,
        isOpen: ref.watch(openElemetsIdProvider).contains(node.nodeId),
        title: name,
        subtitle: createField,
        trailing: HorizontalOption(node),
        children: node.type == NodeType.street
            ? [BuildingsWidget(parrentId: node.nodeId)]
            : [NestListWidget(parrentId: node.nodeId)],
      ),
    );
  }
}
