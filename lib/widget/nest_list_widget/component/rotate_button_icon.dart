import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/provider/open_elements_id_provider.dart';

class RotateButtonIcon extends StatefulWidget {
  final bool isOpen;
  final int id;

  const RotateButtonIcon({
    super.key,
    required this.isOpen,
    required this.id,
  });

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

    final tween = widget.isOpen
        ? Tween(begin: 1.0, end: 0.75)
        : Tween(begin: 0.75, end: 1.0);

    _animation = tween
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
      child: Consumer(
        builder: (context, ref, _) {
          return IconButton(
            icon: const Icon(Icons.expand_more),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }

              ref.read(openElemetsIdProvider.notifier).change(id: widget.id);
            },
          );
        },
      ),
    );
  }
}
