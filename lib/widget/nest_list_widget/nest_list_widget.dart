import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/provider/node_list_provider.dart';
import 'package:izb_ui/provider/open_elements_id_provider.dart';
import 'package:izb_ui/widget/nest_list_widget/component/add_element_button.dart';
import 'package:izb_ui/widget/nest_list_widget/component/element_widget.dart';

class NestListWidget extends HookConsumerWidget {
  const NestListWidget({
    required this.parrentId,
    super.key,
  });

  final int parrentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final root = ref.watch(nodeListProvider(parrentId));
    final _ = ref.watch(openElemetsIdProvider);

    return root.when(
      data: (data) => ListView.builder(
        shrinkWrap: true,
        itemCount: data.length + 1,
        itemBuilder: (context, index) {
          if (index != data.length) {
            final node = data[index];
            return ElementWidget(node);
          } else {
            return parrentId == 0 ? AddElementButton(parrentId) : null;
          }
        },
      ),
      error: (_, __) => const Center(child: Text('Ошибка')),
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
