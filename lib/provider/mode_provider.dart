import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/enum/menu.dart';
import 'package:izb_ui/enum/mode.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/provider/menu_provider.dart';

class ModeNotifier extends FamilyNotifier<Mode, Node> {
  @override
  Mode build(Node arg) {
    return Mode.noEdit;
  }

  void setEdit() {
    final before = ref.read(beforeModeProvider);
    if (before != null) {
      ref.read(modeProvider(before).notifier).state = Mode.noEdit;
    }

    final beforeMenu = ref.read(beforeMenuProvider);
    if (beforeMenu != null) {
      ref.read(menuProvider(beforeMenu).notifier).state = Menu.hide;
    }

    state = Mode.edit;

    //arg family value -- node
    ref.read(beforeModeProvider.notifier).state = arg;
  }

  void setNoEdit() {
    state = Mode.noEdit;
    ref.read(beforeModeProvider.notifier).state = null;
  }

  void setCreate() {
    state = Mode.create;
  }
}

final modeProvider =
    NotifierProvider.family<ModeNotifier, Mode, Node>(ModeNotifier.new);

final beforeModeProvider = StateProvider<Node?>((ref) => null);
