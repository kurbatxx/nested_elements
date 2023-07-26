import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/enum/mode.dart';
import 'package:izb_ui/enum/node_type.dart';
import 'package:izb_ui/provider/loading_state_provider.dart';
import 'package:izb_ui/provider/node_list_provider.dart';
import 'package:izb_ui/theme/theme.dart';

class AddElementButton extends HookConsumerWidget {
  const AddElementButton(this.parrentId, {super.key});

  final int parrentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingStateProvider);

    final editcontroller = useTextEditingController(text: '');
    final mode = useState(Mode.noEdit);

    final focus = useFocusNode();
    final hasSubmit = useState(false);

    focus.addListener(() {
      if (!focus.hasFocus) {
        if (!hasSubmit.value) {
          mode.value = Mode.noEdit;
        }
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: switch (mode.value) {
        Mode.create => TextFormField(
            controller: editcontroller,
            onFieldSubmitted: (value) async => {
              hasSubmit.value = true,
              await ref.read(nodeListProvider(parrentId).notifier).createNode(
                    parrentId: parrentId,
                    name: editcontroller.text,
                    type: NodeType.address,
                  ),
              editcontroller.clear(),
              mode.value = Mode.noEdit,
              hasSubmit.value = false
            },
            decoration: crInputDec('Введите название элемента', isLoading),
            autofocus: true,
            focusNode: focus,
          ),
        Mode.noEdit => FilledButton(
            onPressed: () => mode.value = Mode.create,
            child: const Text('Добавить элемент'),
          ),
        _ => null,
      },
    );
  }
}
