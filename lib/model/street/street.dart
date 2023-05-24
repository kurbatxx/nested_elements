// {
//     "street_id": 5,
//     "street_uuid": "778d1c3b-cf00-438d-bc31-095f991e2247",
//     "street_name": "Букетова"
//   }

import 'package:freezed_annotation/freezed_annotation.dart';

part 'street.freezed.dart';
part 'street.g.dart';

@freezed
class Street with _$Street {
  //@JsonSerializable(explicitToJson: true)
  const factory Street({
    @JsonKey(name: 'street_id') required int streetId,
    @JsonKey(name: 'street_uuid') required String streetUuid,
    @JsonKey(name: 'street_name') required String streetName,
  }) = _Street;

  factory Street.fromJson(Map<String, dynamic> json) => _$StreetFromJson(json);
}
