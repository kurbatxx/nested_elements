import 'package:freezed_annotation/freezed_annotation.dart';

part 'building.freezed.dart';
part 'building.g.dart';

@freezed
class Building with _$Building {
  //@JsonSerializable(explicitToJson: true)
  const factory Building({
    @JsonKey(name: 'building_id') required int buildingId,
    @JsonKey(name: 'street_id') required int streetId,
    @JsonKey(name: 'building_name') required String buildingName,
  }) = _Building;

  factory Building.fromJson(Map<String, dynamic> json) =>
      _$BuildingFromJson(json);
}
