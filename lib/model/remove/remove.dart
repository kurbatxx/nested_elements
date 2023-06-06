import 'package:dart_mappable/dart_mappable.dart';
part 'remove.mapper.dart';

@MappableClass()
class Remove with RemoveMappable {
  final int count;
  final int parrentId;

  Remove({
    @MappableField(key: 'elements_count') required this.count,
    @MappableField(key: 'parrent_id') required this.parrentId,
  });

  static const fromMap = RemoveMapper.fromMap;
}
