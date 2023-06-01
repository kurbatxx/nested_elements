import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/widget/nest_list_widget/nest_widget.dart';

//final menuProvider = StateProvider.family<Menu, Node>((ref, node) => Menu.hide);

class MenuNotifier extends Notifier<Menu> {
  @override
  Menu build() {
    return Menu.hide;
  }

  void show(Node node) {
    state = Menu.show;

    final before = ref.read(beforeMenuProvider);
    if (before != null) {
      ref.read(menuProvider(before).notifier).state = Menu.hide;
    }
    ref.read(beforeMenuProvider.notifier).state = node;
  }

  void hide() {
    state = Menu.hide;
    ref.read(beforeMenuProvider.notifier).state = null;
  }
}

final menuProvider =
    NotifierProvider.family<MenuNotifier, Menu, Node>(MenuNotifier.new);

final beforeMenuProvider = StateProvider<Node?>((ref) => null);
