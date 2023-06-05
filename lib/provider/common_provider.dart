import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/provider/menu_provider.dart';
import 'package:izb_ui/provider/mode_provider.dart';

final commonProvider = Provider((ref) => Common(ref));

class Common {
  final Ref ref;
  const Common(this.ref);

  void setDefault() {
    modeDefault();
    menuDefault();
  }

  void modeDefault() {
    final before = ref.read(beforeModeProvider);
    if (before != null) {
      ref.read(modeProvider(before).notifier).setNoEdit();
    }
  }

  void menuDefault() {
    final before = ref.read(beforeMenuProvider);
    if (before != null) {
      ref.read(menuProvider(before).notifier).hide();
    }
  }
}
