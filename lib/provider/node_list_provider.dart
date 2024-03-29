import 'dart:async';
import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/enum/node_type.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:http/http.dart' as http;
import 'package:izb_ui/provider/ip_provider.dart';
import 'package:izb_ui/provider/loading_state_provider.dart';

import 'dart:developer' as dev show log;

final nodeListProvider =
    AsyncNotifierProvider.family<AsyncNodesNotifier, List<Node>, int>(
        AsyncNodesNotifier.new);

class AsyncNodesNotifier extends FamilyAsyncNotifier<List<Node>, int> {
  @override
  Future<List<Node>> build(int arg) async {
    await Future.delayed(const Duration(seconds: 1));

    final parrentId = arg;
    final url = Uri.http(ref.read(ipProvider), '/get_nodes/$parrentId');
    final response = await http.get(url);

    List<dynamic> jsonList =
        json.decode(utf8.decode(response.bodyBytes)) as List;
    return jsonList.map((e) => NodeMapper.fromMap(e)).toList();
  }

  Future<void> updateNodeName(Node element, String name) async {
    ref.read(loadingStateProvider.notifier).state = true;

    await Future.delayed(const Duration(seconds: 1));
    final url = Uri.http(ref.read(ipProvider), '/update_name');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "node_id": element.nodeId,
        "object": NodeType.address.name,
        "name": name
      }),
    );

    final jsonElement =
        json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    final id = jsonElement["id"] as int;

    state = state.whenData(
      (value) => value.map(
        (e) {
          if (e.nodeId == id) {
            return e.copyWith(nodeName: name);
          }
          return e;
        },
      ).toList(),
    );

    ref.read(loadingStateProvider.notifier).state = false;
  }

  Future<void> createNode({
    required int parrentId,
    required String name,
    required NodeType type,
  }) async {
    ref.read(loadingStateProvider.notifier).state = true;

    Uri url = Uri.http(ref.read(ipProvider), '/create_node');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
          {"parrent_id": parrentId, "node_name": name, "node_type": type.name}),
    );
    state = await AsyncValue.guard(() async => await build(parrentId));
    ref.read(loadingStateProvider.notifier).state = false;
  }

  Future<void> dropNode(Node node) async {
    ref.read(loadingStateProvider.notifier).state = true;

    final url = Uri.http(ref.read(ipProvider), '/drop_node/${node.nodeId}');
    final _ = await http.post(url);

    dev.log('${node.parrentId}');
    state = await AsyncValue.guard(() async => await build(node.parrentId));
    ref.read(loadingStateProvider.notifier).state = false;
  }
}
