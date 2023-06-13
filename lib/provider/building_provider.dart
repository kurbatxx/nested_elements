import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/model/building/building.dart';
import 'package:http/http.dart' as http;
import 'package:izb_ui/provider/ip_provider.dart';

final buildingsProvider =
    FutureProvider.family<List<Building>, int>((ref, sId) async {
  await Future.delayed(const Duration(seconds: 1));

  final url = Uri.http(ref.read(ipProvider), '/get_buildings/$sId');
  final response = await http.get(url);

  List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)) as List;
  List<Building> buildings =
      jsonList.map((e) => BuildingMapper.fromMap(e)).toList();

  return buildings;
});
