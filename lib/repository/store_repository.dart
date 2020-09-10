import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';

import '../model/store.dart';

class StoreRepository {
  final _distance = Distance();

  Future fetch(double lat, double lng) async {
    final List<Store> stores = [];

    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json?lat= 37.631947&lng=127.0180892';
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResult = jsonDecode(response.body);

        final jsonStores = jsonResult['stores'];

        jsonStores.forEach((e) {
          final store = Store.fromJson(e);
          final double km = _distance.as(LengthUnit.Kilometer,
              LatLng(store.lat, store.lng), LatLng(lat, lng));
          store.km = km;
          stores.add(store);
        });
        // isLoading = false;

        print("새로고침 완료");

        return stores.where((e) {
          return e.remainStat == 'plenty' ||
              e.remainStat == 'some' ||
              e.remainStat == 'few';
        }).toList()
          ..sort((a, b) => a.km.compareTo(b.km));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
