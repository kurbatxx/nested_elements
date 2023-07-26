import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/enum/node_type.dart';

final nodeTypeProvider = StateProvider<NodeType>((ref) {
  return NodeType.address;
});
