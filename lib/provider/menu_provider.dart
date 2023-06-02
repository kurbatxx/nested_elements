import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/enum/menu.dart';
import 'package:izb_ui/enum/mode.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/provider/mode_provider.dart';

class MenuNotifier extends FamilyNotifier<Menu, Node> {
  @override
  Menu build(Node arg) {
    return Menu.hide;
  }

  void show() {
    // hide previous menu
    final before = ref.read(beforeMenuProvider);
    if (before != null) {
      ref.read(menuProvider(before).notifier).state = Menu.hide;
    }

    final beforeMode = ref.read(beforeModeProvider);
    if (beforeMode != null) {
      ref.read(modeProvider(beforeMode).notifier).state = Mode.noEdit;
    }

    state = Menu.show;
    //arg family value -- node
    ref.read(beforeMenuProvider.notifier).state = arg;
  }

  void hide() {
    state = Menu.hide;
    ref.read(beforeMenuProvider.notifier).state = null;
  }
}

final menuProvider =
    NotifierProvider.family<MenuNotifier, Menu, Node>(MenuNotifier.new);

final beforeMenuProvider = StateProvider<Node?>((ref) => null);
