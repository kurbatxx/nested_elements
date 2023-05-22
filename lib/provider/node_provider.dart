import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:http/http.dart' as http;

final rootProvider = FutureProvider<List<Node>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));

  final url = Uri.http('127.0.0.1:8080', '/node_with_nest/0');
  final response = await http.get(
    url,
  );
  //print('Response status: ${response.statusCode}');

  List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)) as List;
  List<Node> nodes = jsonList.map((e) => Node.fromJson(e)).toList();

  return nodes;
});
