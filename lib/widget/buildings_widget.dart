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
      data: (data) => ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final building = data[index];

          return ListTile(
            title: Text(building.buildingName),
            subtitle: Text(building.streetId.toString()),
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
