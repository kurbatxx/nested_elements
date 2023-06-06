import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/api/api.dart';
import 'package:izb_ui/enum/mode.dart';
import 'package:izb_ui/provider/loading_state_provider.dart';
import 'package:izb_ui/theme/theme.dart';

class AddElementButton extends HookConsumerWidget {
  const AddElementButton(this.pId, {super.key});

  final int pId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingStateProvider);

    final editcontroller = useTextEditingController(text: '');
    final mode = useState(Mode.noEdit);

    final focus = useFocusNode();

    focus.addListener(() {
      if (!focus.hasFocus) {
        mode.value = Mode.noEdit;
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: switch (mode.value) {
        Mode.create => TextFormField(
            controller: editcontroller,
            onFieldSubmitted: (value) async => {
              await ref
                  .read(apiProvider)
                  .createElement(pId, editcontroller.text),
              editcontroller.clear(),
              mode.value = Mode.noEdit,
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
