import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/model/building/building.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/model/remove/remove.dart';
import 'package:izb_ui/model/street/street.dart';
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

  Future<void> createNestElement(Node node, String name) async {
    await Future.delayed(const Duration(seconds: 1));

    final url = Uri.http(ref.read(ipProvider), '/create_node');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"parrent_id": node.nodeId, "node_name": name}),
    );

    final _ = ref.refresh(nodeProvider(node.parrentId));
    ref.invalidate(nodeProvider(node.nodeId));
  }

  Future<void> dropElement(Node node) async {
    await Future.delayed(const Duration(seconds: 1));

    final url = Uri.http(ref.read(ipProvider), '/drop_node/${node.nodeId}');
    final response = await http.post(url);

    Remove remove =
        Remove.fromJson(json.decode(utf8.decode(response.bodyBytes)));

    if (remove.count == 0) {
      final _ = ref.refresh(nodeProvider(remove.parrentId));
    }
    final _ = ref.refresh(nodeProvider(node.parrentId));
  }

  Future<void> createStreet(Node node, String name) async {
    await Future.delayed(const Duration(seconds: 1));

    final url = Uri.http(ref.read(ipProvider), '/create_street');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"node_id": node.nodeId, "street_name": name}),
    );

    final _ = ref.refresh(nodeProvider(node.parrentId));
    ref.invalidate(nodeProvider(node.nodeId));
  }

  Future<void> updateName<T>(T element, String name) async {
    await Future.delayed(const Duration(seconds: 1));

    final url = Uri.http(ref.read(ipProvider), '/update_name');

    switch (element.runtimeType) {
      case Node:
        element as Node;
        await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({"node_id": element.nodeId, "node_name": name}),
        );

        final _ = ref.refresh(nodeProvider(element.parrentId));
        ref.invalidate(nodeProvider(element.nodeId));
      case Street:
        element as Street;

      case Building:
        element as Building;
    }
  }
}
