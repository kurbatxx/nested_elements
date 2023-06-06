// {
//     "node_id": 19,
//     "parrent_id": 16,
//     "node_name": "Петропавловск",
//     "nested": false
//   },

import 'package:dart_mappable/dart_mappable.dart';
part 'node.mapper.dart';

@MappableClass()
class Node with NodeMappable {
  final int nodeId;
  final int parrentId;
  final String nodeName;
  final String? streetsUuid;
  final bool nested;

  Node({
    @MappableField(key: 'node_id') required this.nodeId,
    @MappableField(key: 'parrent_id') required this.parrentId,
    @MappableField(key: 'node_name') required this.nodeName,
    @MappableField(key: 'streets_uuid') required this.streetsUuid,
    required this.nested,
  });

  static const fromMap = NodeMapper.fromMap;
  //static const fromJson = NodeMapper.fromJson;
}
