// {
//     "street_id": 5,
//     "street_uuid": "778d1c3b-cf00-438d-bc31-095f991e2247",
//     "street_name": "Букетова"
//   }

import 'package:dart_mappable/dart_mappable.dart';
part 'street.mapper.dart';

@MappableClass()
class Street with StreetMappable {
  final int streetId;
  final String streetUuid;
  final String streetName;

  Street({
    @MappableField(key: 'street_id') required this.streetId,
    @MappableField(key: 'street_uuid') required this.streetUuid,
    @MappableField(key: 'street_name') required this.streetName,
  });

  static const fromMap = StreetMapper.fromMap;
}
