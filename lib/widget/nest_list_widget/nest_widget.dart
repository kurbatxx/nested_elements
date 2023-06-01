import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/api/api.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/provider/menu_provider.dart';
import 'package:izb_ui/provider/node_provider.dart';
import 'package:izb_ui/theme/theme.dart';

class NestListWidget extends HookConsumerWidget {
  const NestListWidget({
    required this.pId,
    super.key,
  });

  final int pId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final root = ref.watch(nodeProvider(pId));

    return root.when(
      data: (data) => ListView.builder(
        shrinkWrap: true,
        itemCount: data.length + 1,
        itemBuilder: (context, index) {
          if (index != data.length) {
            final node = data[index];
            return ElementWidget(node);
          } else {
            return AddElementButton(pId);
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

class ElementWidget extends HookConsumerWidget {
  const ElementWidget(this.node, {super.key});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Widget name = Text(node.nodeName);

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

class AddElementButton extends HookConsumerWidget {
  const AddElementButton(this.pId, {super.key});

  final int pId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editcontroller = useTextEditingController(text: '');
    final mode = useState(Mode.noEdit);

    final focus = useFocusNode();

    focus.addListener(() {
      if (!focus.hasFocus) {
        mode.value = Mode.noEdit;
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: switch (mode.value) {
        Mode.create => TextFormField(
            controller: editcontroller,
            onFieldSubmitted: (value) async => {
              await ref
                  .read(apiProvider)
                  .createElement(pId, editcontroller.text),
              editcontroller.clear(),
              mode.value = Mode.noEdit,
            },
            decoration: crInputDec('Введите название элемента'),
            autofocus: true,
            focusNode: focus,
          ),
        Mode.noEdit => FilledButton(
            onPressed: () => mode.value = Mode.create,
            child: const Text('Добавить элемент'),
          ),
        _ => null,
      },
    );
  }
}

enum Menu {
  show,
  hide,
}

class HorizontalOption extends HookConsumerWidget {
  const HorizontalOption(this.node, {super.key});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menu = ref.watch(menuProvider(node));

    //final menu = useState(Menu.hide);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        switch (menu) {
          Menu.hide => FilledButton(
              onPressed: () {
                ref.read(menuProvider(node).notifier).state = Menu.show;

                final before = ref.read(beforeMenuProvider);
                if (before != null) {
                  ref.read(menuProvider(before).notifier).state = Menu.hide;
                }
                ref.read(beforeMenuProvider.notifier).state = node;

                //menu.value = Menu.show;
              },
              child: const Text('option'),
            ),
          Menu.show => Row(
              children: [
                FilledButton(
                  onPressed: () {},
                  child: const Text('Создать подкаталог'),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Редактировать'),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Удалить'),
                ),
                FilledButton(
                  onPressed: () {
                    ref.read(menuProvider(node).notifier).state = Menu.hide;
                    ref.read(beforeMenuProvider.notifier).state = null;
                    //menu.value = Menu.hide;
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

// final node = data[index];
// if (node.nested || node.streetsUuid != null) {
//   return ExpansionTile(
//     title: TextOrEditorWidget(
//       switcher: editSwither,
//       focus: focus,
//       name: node.nodeName,
//     ),
//     trailing: FilledButton(
//       onPressed: () {
//         editSwither.value = Mode.edit;
//       },
//       child: const Text('Редактировать'),
//     ),
//     // title: Text(node.nodeName),
//     subtitle: Text(node.nested.toString()),
//     expandedAlignment: Alignment.centerLeft,
//     childrenPadding: const EdgeInsets.only(left: 32.0),
//     children: node.streetsUuid != null
//         ? [StreetsWidget(uuid: node.streetsUuid ?? '')]
//         : [NestListWidget(pId: node.nodeId)],
//   );
// } else {
//   return EmptyNode(node: node);
// }

enum Mode {
  create,
  edit,
  noEdit,
}

enum Item {
  catalog,
  street,
}

class EmptyNode extends HookConsumerWidget {
  const EmptyNode({
    super.key,
    required this.node,
  });

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editSwither = useState<Mode>(Mode.noEdit);
    final visible = useState(Menu.hide);
    final item = useState(Item.catalog);
    //
    final editcontroller = useTextEditingController(text: '');
    final focus = useFocusNode();

    focus.addListener(() {
      if (!focus.hasFocus) {
        editSwither.value = Mode.noEdit;
      }
    });

    return Column(
      children: [
        ListTile(
          title: Text(node.nodeName),
          trailing: switch (visible.value) {
            Menu.hide => FilledButton(
                onPressed: () => visible.value = Menu.show,
                child: const Text("Показать"),
              ),
            Menu.show => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  switch (editSwither.value) {
                    Mode.create => const SizedBox(),
                    Mode.edit => const SizedBox(),
                    Mode.noEdit => Row(
                        children: [
                          FilledButton(
                            onPressed: () {
                              editSwither.value = Mode.create;
                              item.value = Item.street;
                            },
                            child: const Text('Добавить улицу'),
                          ),
                          FilledButton(
                            onPressed: () {
                              editSwither.value = Mode.create;
                              item.value = Item.catalog;
                            },
                            child: const Text('Добавить подкаталог'),
                          ),
                        ],
                      )
                  },
                  FilledButton(
                    onPressed: () async {
                      await ref.read(apiProvider).dropElement(node);
                    },
                    child: const Text('Удалить'),
                  ),
                  FilledButton(
                    onPressed: () => visible.value = Menu.hide,
                    child: const Text('Скрыть'),
                  ),
                ],
              ),
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: switch (editSwither.value) {
            Mode.create => TextFormField(
                onFieldSubmitted: (_) async => {
                  switch (item.value) {
                    Item.catalog => await ref
                        .read(apiProvider)
                        .createNestElement(node, editcontroller.text),
                    Item.street => await ref
                        .read(apiProvider)
                        .createStreet(node, editcontroller.text),
                  },
                  editcontroller.clear(),
                  editSwither.value = Mode.noEdit
                },
                controller: editcontroller,
                decoration: crInputDec(switch (item.value) {
                  Item.catalog => 'Введите название подкаталога',
                  Item.street => 'Введите название улицы',
                }),
                autofocus: true,
                focusNode: focus,
              ),
            Mode.noEdit => const SizedBox(),
            Mode.edit => const SizedBox()
          },
        ),
      ],
    );
  }
}

class TextOrEditorWidget extends HookConsumerWidget {
  const TextOrEditorWidget({
    super.key,
    required this.switcher,
    required this.name,
    required this.focus,
  });

  final String name;
  final ValueNotifier<Mode> switcher;
  final FocusNode focus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final switcher = useState<Edit>(Edit.noEdit);
    final editcontroller = useTextEditingController(text: '');

    return switch (switcher.value) {
      Mode.noEdit => const Text("Text"),
      Mode.edit => TextFormField(
          controller: editcontroller,
          focusNode: focus,
        ),
      _ => const SizedBox(),
    };
  }
}
