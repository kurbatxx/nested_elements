import 'package:hooks_riverpod/hooks_riverpod.dart';

final openElemetsIdProvider = NotifierProvider<OpenElemetsIdNotifier, Set<int>>(
    OpenElemetsIdNotifier.new);

class OpenElemetsIdNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() {
    return {};
  }

  void change({required int id}) {
    if (state.contains(id)) {
      state.remove(id);
    } else {
      state.add(id);
    }

    state = Set.of(state);
  }
}
