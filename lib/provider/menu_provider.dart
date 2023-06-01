import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/widget/nest_list_widget/nest_widget.dart';

final menuProvider = StateProvider.family<Menu, Node>((ref, node) => Menu.hide);

final beforeMenuProvider = StateProvider<Node?>((ref) => null);
