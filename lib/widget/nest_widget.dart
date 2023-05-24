import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/provider/node_provider.dart';
import 'package:izb_ui/widget/streets_widget.dart';

class NestWidget extends ConsumerWidget {
  final int pId;

  const NestWidget({
    required this.pId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final root = ref.watch(nestProvider(pId));

    return root.when(
      data: (data) => ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final node = data[index];
          if (node.nested || node.streets_uuid != null) {
            return ExpansionTile(
              title: Text(node.nodeName),
              subtitle: Text(node.nested.toString()),
              expandedAlignment: Alignment.centerLeft,
              childrenPadding: const EdgeInsets.only(left: 32.0),
              children: node.streets_uuid != null
                  ? [StreetsWidget(uuid: node.streets_uuid ?? '')]
                  : [NestWidget(pId: node.nodeId)],
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
