import 'package:dart_mappable/dart_mappable.dart';
part 'node_type.mapper.dart';

@MappableEnum()
enum NodeType { address, street, building }
