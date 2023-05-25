import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:http/http.dart' as http;
import 'package:izb_ui/provider/ip_provider.dart';

final nodeProvider = FutureProvider.family<List<Node>, int>((ref, pId) async {
  await Future.delayed(const Duration(seconds: 1));

  final url = Uri.http(ref.read(ipProvider), '/node_with_nest/$pId');
  final response = await http.get(url);

  List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)) as List;
  List<Node> nodes = jsonList.map((e) => Node.fromJson(e)).toList();

  return nodes;
});
