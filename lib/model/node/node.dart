import 'package:dart_mappable/dart_mappable.dart';
import 'package:izb_ui/enum/node_type.dart';
part 'node.mapper.dart';

@MappableClass()
class Node with NodeMappable {
  final int nodeId;
  final int parrentId;
  final String nodeName;
  final String? deputatUuid;
  final bool hasNest;
  final NodeType type;

  Node({
    @MappableField(key: 'node_id') required this.nodeId,
    @MappableField(key: 'parrent_id') required this.parrentId,
    @MappableField(key: 'node_name') required this.nodeName,
    @MappableField(key: 'deputat_uuid') required this.deputatUuid,
    @MappableField(key: 'has_nest') required this.hasNest,
    @MappableField(key: 'node_type') required this.type,
  });

  static const fromMap = NodeMapper.fromMap;
  //static const fromJson = NodeMapper.fromJson;
}
