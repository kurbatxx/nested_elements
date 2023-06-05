import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/enum/mode.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/provider/common_provider.dart';

class ModeNotifier extends FamilyNotifier<Mode, Node> {
  @override
  Mode build(Node arg) {
    return Mode.noEdit;
  }

  void setEdit() {
    ref.read(commonProvider).setDefault();
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
