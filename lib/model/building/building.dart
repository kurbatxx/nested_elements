import 'package:dart_mappable/dart_mappable.dart';
part 'building.mapper.dart';

@MappableClass()
class Building with BuildingMappable {
  final int buildingId;
  final int streetId;
  final String buildingName;

  Building({
    @MappableField(key: 'building_id') required this.buildingId,
    @MappableField(key: 'street_id') required this.streetId,
    @MappableField(key: 'building_name') required this.buildingName,
  });

  static const fromMap = BuildingMapper.fromMap;
}
