import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/api/api.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/provider/node_provider.dart';
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

    final root = ref.watch(nodeProvider(pId));

    return root.when(
      data: (data) => SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              onFieldSubmitted: (value) async => {
                await ref
                    .read(apiProvider)
                    .createElement(pId, editcontroller.text),
                editcontroller.clear(),
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsetsDirectional.all(10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3, color: Colors.greenAccent), //<-- SEE HERE
                ),
                isCollapsed: true,
              ),
              controller: editcontroller,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
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
              },
            ),
          ],
        ),
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
    final state = useState<Edit>(Edit.noEdit);

    return ListTile(
        title: Text(node.nodeName),
        subtitle: switch (state.value) {
          Edit.edit => Text(node.nested.toString()),
          Edit.noEdit => Text('var2 '),
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () => switch (state.value) {
                Edit.edit => {
                    state.value = Edit.noEdit,
                    print("1"),
                  },
                Edit.noEdit => {
                    {
                      state.value = Edit.edit,
                      print("2"),
                    },
                  }
              },
              child: const Text('Добавить подкаталог'),
            ),
            FilledButton(
              onPressed: () async {
                await ref.read(apiProvider).dropElement(node);
              },
              child: const Text('Удалить'),
            ),
          ],
        ));
  }
}
