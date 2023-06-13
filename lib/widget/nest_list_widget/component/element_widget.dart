import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/api/api.dart';
import 'package:izb_ui/enum/mode.dart';
import 'package:izb_ui/enum/node_type.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/provider/common_provider.dart';
import 'package:izb_ui/provider/loading_state_provider.dart';
import 'package:izb_ui/provider/mode_provider.dart';
import 'package:izb_ui/provider/node_provider.dart';
import 'package:izb_ui/provider/node_type_provider.dart';
import 'package:izb_ui/theme/theme.dart';
import 'package:izb_ui/widget/custom_expansion_tile.dart';
import 'package:izb_ui/widget/nest_list_widget/component/horizontal_option.dart';
import 'package:izb_ui/widget/nest_list_widget/nest_list_widget.dart';
import 'package:izb_ui/widget/streets_widget.dart';

class ElementWidget extends HookConsumerWidget {
  const ElementWidget(this.node, {super.key});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeProvider(node));
    final nodeType = ref.watch(nodeTypeProvider);
    final isLoading = ref.watch(loadingStateProvider);

    final textController = useTextEditingController(text: node.nodeName);
    final focus = useFocusNode();

    final createController = useTextEditingController(text: '');

    useEffect(() {
      if (!focus.hasFocus && mode != Mode.edit) {
        textController.text = node.nodeName;
        createController.text = '';
      }

      return null;
    });

    final Widget createField = switch (mode) {
      Mode.create => TextFormField(
          controller: createController,
          decoration: crInputDec(
              switch (nodeType) {
                NodeType.node => 'Введите название подкаталога',
                NodeType.street => 'Введите название улицы',
                _ => '',
              },
              isLoading),
          onFieldSubmitted: (_) {
            switch (nodeType) {
              case NodeType.node:
                {
                  ref
                      .read(apiProvider)
                      .createNestElement(node, createController.text);
                }
              case NodeType.street:
                {
                  ref
                      .read(apiProvider)
                      .createStreet(node, createController.text);
                }
              default:
                {}
            }
            ref.read(commonProvider).setDefault();
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
                .read(nodeProvider(node.parrentId).notifier)
                .updateName(node, textController.text);
          }),
      _ => Text(node.nodeName),
    };

    return GestureDetector(
      onTap: () {
        ref.read(commonProvider).setDefault();
      },
      child: CustomExspansionWidget(
        nested: node.nested || node.streetsUuid != null,
        title: name,
        subtitle: createField,
        trailing: HorizontalOption(node),
        children: node.streetsUuid != null
            ? [StreetsWidget(uuid: node.streetsUuid ?? '')]
            : [NestListWidget(pId: node.nodeId)],
      ),
    );

    if (node.nested || node.streetsUuid != null) {
      return ExpansionTile(
        onExpansionChanged: (_) {
          ref.read(commonProvider).setDefault();
        },
        leading: const Icon(
          Icons.keyboard_arrow_right_outlined,
        ),
        title: crOffset(name),
        tilePadding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
        subtitle: crOffset(createField),
        trailing: HorizontalOption(node),
        //--//--//
        expandedAlignment: Alignment.centerLeft,
        childrenPadding: const EdgeInsets.only(left: 32.0),
        children: node.streetsUuid != null
            ? [StreetsWidget(uuid: node.streetsUuid ?? '')]
            : [NestListWidget(pId: node.nodeId)],
      );
    } else {
      return GestureDetector(
        onTap: () {
          ref.read(commonProvider).setDefault();
        },
        child: ListTile(
          contentPadding:
              const EdgeInsetsDirectional.only(start: 24 + 8, end: 8),
          title: name,
          subtitle: createField,
          trailing: HorizontalOption(node),
        ),
      );
    }
  }
}
