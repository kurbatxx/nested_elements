import 'dart:async';
import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:izb_ui/enum/node_type.dart';
import 'package:izb_ui/model/node/node.dart';
import 'package:http/http.dart' as http;
import 'package:izb_ui/model/remove/remove.dart';
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

    final pId = arg;
    final url = Uri.http(ref.read(ipProvider), '/node_with_nest/$pId');
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
        "object": NodeType.node.name,
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

  Future<void> addNode(String name) async {
    ref.read(loadingStateProvider.notifier).state = true;

    Uri url = Uri.http(ref.read(ipProvider), '/create_node');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"parrent_id": 0, "node_name": name}),
    );
    dev.log('+++++++++');
    state = await AsyncValue.guard(() async => await build(0));
    ref.read(loadingStateProvider.notifier).state = false;
  }

  Future<void> dropNode(Node node) async {
    ref.read(loadingStateProvider.notifier).state = true;

    final url = Uri.http(ref.read(ipProvider), '/drop_node/${node.nodeId}');
    final response = await http.post(url);

    Remove _remove =
        RemoveMapper.fromMap(json.decode(utf8.decode(response.bodyBytes)));

    // if (remove.count == 0) {
    //   final _ = ref.refresh(nodeListProvider(node.parrentId));
    // }

    // state = await AsyncValue.guard(() => build(arg));
    dev.log('${node.parrentId}');
    state = await AsyncValue.guard(() async => await build(node.parrentId));
    ref.read(loadingStateProvider.notifier).state = false;
  }

  Future<void> createNestedNode(Node node, String name) async {
    dev.log('CREATE NESTED NODE');
    ref.read(loadingStateProvider.notifier).state = true;

    final url = Uri.http(ref.read(ipProvider), '/create_node');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"parrent_id": node.nodeId, "node_name": name}),
    );

    state = await AsyncValue.guard(() async => await build(arg));
    ref.read(loadingStateProvider.notifier).state = false;
  }
}
