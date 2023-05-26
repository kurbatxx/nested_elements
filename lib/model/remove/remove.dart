import 'package:freezed_annotation/freezed_annotation.dart';

part 'remove.freezed.dart';
part 'remove.g.dart';

@freezed
class Remove with _$Remove {
  //@JsonSerializable(explicitToJson: true)
  const factory Remove({
    @JsonKey(name: 'elements_count') required int count,
    @JsonKey(name: 'parrent_id') required int parrentId,
  }) = _Remove;

  factory Remove.fromJson(Map<String, dynamic> json) => _$RemoveFromJson(json);
}
