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
                  ? RotateButtonIcon(
                      onPressed: () {},
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

class RotateButtonIcon extends StatefulWidget {
  final VoidCallback? onPressed;

  const RotateButtonIcon({super.key, required this.onPressed});

  @override
  State<RotateButtonIcon> createState() => _RotateButtonIconState();
}

class _RotateButtonIconState extends State<RotateButtonIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _animation = Tween(begin: 0.75, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: IconButton(
        icon: const Icon(Icons.expand_more),
        onPressed: () {
          widget.onPressed;
          if (_controller.isDismissed) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        },
      ),
    );
  }
}
