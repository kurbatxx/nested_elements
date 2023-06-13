import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomExspansionWidget extends HookConsumerWidget {
  const CustomExspansionWidget({
    super.key,
    required this.nested,
    this.title,
    this.subtitle,
    this.trailing,
    this.children,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final List<Widget>? children;
  final bool nested;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expended = useState(false);
    final nest = useState(nested);

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blueAccent,
          ),
          borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              nest.value
                  ? expended.value
                      ? Transform.rotate(
                          angle: pi / 2,
                          child: CustomIconButton(expended: expended),
                        )
                      : CustomIconButton(expended: expended)
                  : const SizedBox.square(
                      dimension: 40,
                    ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title ?? const SizedBox(),
                    subtitle ?? const SizedBox()
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
              trailing ?? const SizedBox()
            ],
          ),
          if (expended.value)
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                children: children ?? [],
              ),
            ),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.expended,
  });

  final ValueNotifier<bool> expended;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 16.0,
      icon: const Icon(Icons.chevron_right),
      onPressed: () {
        expended.value = !expended.value;
      },
    );
  }
}
