import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:izb_ui/model/street/street.dart';
import 'package:izb_ui/provider/ip_provider.dart';

final streetsProvider =
    FutureProvider.family<List<Street>, String>((ref, uuid) async {
  await Future.delayed(const Duration(seconds: 1));
  print(uuid);

  final url = Uri.http(ref.read(ipProvider), '/get_streets/$uuid');
  final response = await http.get(url);

  List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)) as List;
  List<Street> streets = jsonList.map((e) => Street.fromJson(e)).toList();

  return streets;
});
