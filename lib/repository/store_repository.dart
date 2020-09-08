import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/store.dart';

class StoreRepository {
  Future fetch() async {
    final List<Store> stores = [];

    // setState(() {
    //   isLoading = true;
    // });
    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json?lat= 37.631947&lng=127.0180892';

    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final jsonResult = jsonDecode(response.body);

    final jsonStores = jsonResult['stores'];

    jsonStores.forEach((e) {
      final store = Store.fromJson(e);
      stores.add(store);
    });
    // isLoading = false;

    print("새로고침 완료");

    return stores.where((e) {
      return e.remainStat == 'plenty' ||
          e.remainStat == 'some' ||
          e.remainStat == 'few';
    }).toList();
  }
}
