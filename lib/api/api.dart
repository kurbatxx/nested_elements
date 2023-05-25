import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/provider/ip_provider.dart';
import 'package:http/http.dart' as http;
import 'package:izb_ui/provider/node_provider.dart';

final apiProvider = Provider((ref) => Api(ref));

class Api {
  final Ref ref;
  const Api(this.ref);

  Future<void> createElement(int pId, String name) async {
    await Future.delayed(const Duration(seconds: 1));

    final url = Uri.http(ref.read(ipProvider), '/create_node');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"parrent_id": pId, "node_name": name}),
    );

    final _ = ref.refresh(nodeProvider(pId));
  }

  Future<void> dropElement(Node node) async {
    await Future.delayed(const Duration(seconds: 1));

    final url = Uri.http(ref.read(ipProvider), '/drop_node/${node.nodeId}');
    await http.post(url);

    final _ = ref.refresh(nodeProvider(node.parrentId));
  }
}
