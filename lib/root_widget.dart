import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/provider/node_provider.dart';

class RootWidget extends ConsumerWidget {
  const RootWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final root = ref.watch(rootProvider);

    return root.when(
      data: (root) => ListView.builder(
        itemCount: root.length,
        itemBuilder: (context, index) {
          final node = root[index];
          if (node.nested) {
            return ExpansionTile(
              title: Text(node.nodeName),
              subtitle: Text(node.nested.toString()),
              expandedAlignment: Alignment.centerLeft,
              childrenPadding: const EdgeInsets.only(left: 32.0),
              children: const [Text("FF"), Text("AA")],
            );
          } else {
            return ListTile(
              title: Text(node.nodeName),
              subtitle: Text(node.nested.toString()),
            );
          }
        },
      ),
      error: (_, __) => const Text('Ошибка'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
