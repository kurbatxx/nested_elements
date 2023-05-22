// {
//     "node_id": 19,
//     "parrent_id": 16,
//     "node_name": "Петропавловск",
//     "nested": false
//   },

import 'package:freezed_annotation/freezed_annotation.dart';

part 'node.freezed.dart';
part 'node.g.dart';

@freezed
class Node with _$Node {
  //@JsonSerializable(explicitToJson: true)
  const factory Node({
    @JsonKey(name: 'node_id') required int nodeId,
    @JsonKey(name: 'parrent_id') required int parrentId,
    @JsonKey(name: 'node_name') required String nodeName,
    required bool nested,
  }) = _Node;

  factory Node.fromJson(Map<String, dynamic> json) => _$NodeFromJson(json);
}
