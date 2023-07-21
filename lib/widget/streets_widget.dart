import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/provider/streets_provider.dart';
import 'package:izb_ui/widget/buildings_widget.dart';
import 'package:izb_ui/widget/custom_expansion_tile.dart';

class StreetsWidget extends ConsumerWidget {
  final String uuid;

  const StreetsWidget({
    required this.uuid,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final root = ref.watch(streetsProvider(uuid));

    return root.when(
      data: (data) => ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final street = data[index];

          return CustomExspansionWidget(
            isOpen: false,
            id: street.streetId,
            nested: street.nested,
            title: Text(street.streetName),
            children: [BuildingsWidget(sId: street.streetId)],
          );
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
