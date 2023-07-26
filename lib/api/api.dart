import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/enum/node_type.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:izb_ui/provider/ip_provider.dart';
import 'package:http/http.dart' as http;
import 'package:izb_ui/provider/loading_state_provider.dart';
import 'package:izb_ui/provider/node_list_provider.dart';
import 'package:izb_ui/provider/streets_provider.dart';

final apiProvider = Provider((ref) => Api(ref));

class Api {
  final Ref ref;
  const Api(this.ref);

  Future<void> createElement(int pId, String name) async {
    ref.read(loadingStateProvider.notifier).state = true;

    await Future.delayed(const Duration(seconds: 5));

    final url = Uri.http(ref.read(ipProvider), '/create_node');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"parrent_id": pId, "node_name": name}),
    );

    ref.read(loadingStateProvider.notifier).state = false;
  }

  Future<void> createNestElement(Node node, String name) async {
    await Future.delayed(const Duration(seconds: 1));

    final url = Uri.http(ref.read(ipProvider), '/create_node');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"parrent_id": node.nodeId, "node_name": name}),
    );

    final _ = ref.refresh(nodeListProvider(node.parrentId));
    ref.invalidate(nodeListProvider(node.nodeId));
  }

  Future<void> createStreet(Node node, String name) async {
    await Future.delayed(const Duration(seconds: 1));

    final url = Uri.http(ref.read(ipProvider), '/create_street');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"node_id": node.nodeId, "street_name": name}),
    );

    final _ = ref.refresh(nodeListProvider(node.parrentId));
    if (node.deputatUuid != null) {
      final _ = ref.refresh(streetsProvider(node.deputatUuid!));
    }
  }

  Future<void> updateName<T>(T element, String name) async {
    await Future.delayed(const Duration(seconds: 1));

    final url = Uri.http(ref.read(ipProvider), '/update_name');

    if (element is Node) {
      await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "node_id": element.nodeId,
          "object": NodeType.address.name,
          "name": name,
        }),
      );

      final _ = ref.refresh(nodeListProvider(element.parrentId));
      ref.invalidate(nodeListProvider(element.nodeId));
      return;
    }
  }
}
