import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/provider/building_provider.dart';

class BuildingsWidget extends ConsumerWidget {
  final int sId;

  const BuildingsWidget({
    required this.sId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final root = ref.watch(buildingsProvider(sId));

    return root.when(
      data: (data) =>
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Wrap(
          spacing: 16.0,
          children: [
            for (final item in data)
              Chip(
                label: Text(item.buildingName),
              )
          ],
        ),
        UnconstrainedBox(
          child: FilledButton(onPressed: () {}, child: const Text('Жми')),
        )
      ]),
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
