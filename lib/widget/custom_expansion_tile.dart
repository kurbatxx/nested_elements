import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/widget/nest_list_widget/component/expanded_section.dart';
import 'package:izb_ui/widget/nest_list_widget/component/rotate_button_icon.dart';

class CustomExspansionWidget extends HookConsumerWidget {
  const CustomExspansionWidget({
    super.key,
    required this.nested,
    required this.id,
    required this.isOpen,
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
  final int id;
  final bool isOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              nested
                  ? RotateButtonIcon(
                      isOpen: isOpen,
                      id: id,
                    )
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
          ExpandedSection(
            expand: isOpen,
            child: isOpen
                ? Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    //child: NestListWidget(parrentId: id),
                    child: Column(
                      children: children ?? [],
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
