import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomExspansionWidget extends HookConsumerWidget {
  const CustomExspansionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expended = useState(false);
    final nested = useState(true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            nested.value
                ? IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: () {
                      expended.value = !expended.value;
                    },
                  )
                : const SizedBox(),
            Text('Placeholder')
          ],
        ),
        if (expended.value)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: [
                CustomExspansionWidget(),
                CustomExspansionWidget(),
              ],
            ),
          ),
      ],
    );
  }
}
