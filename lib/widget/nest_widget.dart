import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/api/api.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/provider/node_provider.dart';
import 'package:izb_ui/theme/theme.dart';
import 'package:izb_ui/widget/streets_widget.dart';

class NestWidget extends HookConsumerWidget {
  final int pId;

  const NestWidget({
    required this.pId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editcontroller = useTextEditingController(text: '');
    final editSwither = useState(Edit.noEdit);

    final focus = useFocusNode();

    focus.addListener(() {
      if (!focus.hasFocus) {
        editSwither.value = Edit.noEdit;
      }
    });

    final root = ref.watch(nodeProvider(pId));

    return root.when(
      data: (data) => ListView.builder(
        shrinkWrap: true,
        itemCount: data.length + 1,
        itemBuilder: (context, index) {
          if (index == data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: switch (editSwither.value) {
                Edit.edit => TextFormField(
                    controller: editcontroller,
                    onFieldSubmitted: (value) async => {
                      await ref
                          .read(apiProvider)
                          .createElement(pId, editcontroller.text),
                      editcontroller.clear(),
                      editSwither.value = Edit.noEdit,
                    },
                    decoration: crInputDec('Введите название элемента'),
                    autofocus: true,
                    focusNode: focus,
                  ),
                Edit.noEdit => FilledButton(
                    onPressed: () => editSwither.value = Edit.edit,
                    child: const Text('Добавить элемент'),
                  ),
              },
            );
          } else {
            final node = data[index];
            if (node.nested || node.streetsUuid != null) {
              return ExpansionTile(
                title: Text(node.nodeName),
                subtitle: Text(node.nested.toString()),
                expandedAlignment: Alignment.centerLeft,
                childrenPadding: const EdgeInsets.only(left: 32.0),
                children: node.streetsUuid != null
                    ? [StreetsWidget(uuid: node.streetsUuid ?? '')]
                    : [NestWidget(pId: node.nodeId)],
              );
            } else {
              return EmptyNode(node: node);
            }
          }
        },
      ),
      error: (_, __) => const Text('Ошибка'),
      loading: () => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox.square(
            dimension: 16.0,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

enum Visible {
  show,
  hide,
}

enum Edit {
  edit,
  noEdit,
}

class EmptyNode extends HookConsumerWidget {
  const EmptyNode({
    super.key,
    required this.node,
  });

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editSwither = useState<Edit>(Edit.noEdit);
    final visible = useState(Visible.hide);
    final editcontroller = useTextEditingController(text: '');
    final focus = useFocusNode();

    focus.addListener(() {
      if (!focus.hasFocus) {
        editSwither.value = Edit.noEdit;
      }
    });

    return Column(
      children: [
        ListTile(
          title: Text(node.nodeName),
          trailing: switch (visible.value) {
            Visible.hide => FilledButton(
                onPressed: () => visible.value = Visible.show,
                child: const Text("Показать"),
              ),
            Visible.show => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  switch (editSwither.value) {
                    Edit.edit => const SizedBox(),
                    Edit.noEdit => FilledButton(
                        onPressed: () {
                          editSwither.value = Edit.edit;
                        },
                        child: const Text('Добавить подкаталог'))
                  },
                  FilledButton(
                    onPressed: () async {
                      await ref.read(apiProvider).dropElement(node);
                    },
                    child: const Text('Удалить'),
                  ),
                  FilledButton(
                    onPressed: () => visible.value = Visible.hide,
                    child: const Text('Скрыть'),
                  ),
                ],
              ),
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: switch (editSwither.value) {
            Edit.edit => TextFormField(
                onFieldSubmitted: (value) async => {
                  await ref
                      .read(apiProvider)
                      .createNestElement(node, editcontroller.text),
                  editcontroller.clear(),
                  editSwither.value = Edit.noEdit
                },
                controller: editcontroller,
                decoration: crInputDec('Введите название подкаталога'),
                autofocus: true,
                focusNode: focus,
              ),
            Edit.noEdit => const SizedBox(),
          },
        ),
      ],
    );
  }
}
