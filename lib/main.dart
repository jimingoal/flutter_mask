import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/store.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Store> stores = [];
  var isLoading = true;

  Future fetch() async {
    setState(() {
      isLoading = true;
    });
    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json?lat= 37.631947&lng=127.0180892';

    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final jsonResult = jsonDecode(response.body);

    final jsonStores = jsonResult['stores'];

    setState(() {
      stores.clear();

      jsonStores.forEach((e) {
        final store = Store.fromJson(e);
        stores.add(store);
      });
      isLoading = false;
    });

    print("새로고침 완료");
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마스크 재고 있는곳: ${stores.length}'),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: fetch)],
      ),
      body: isLoading
          ? loadingWidget()
          : ListView(
              children: stores.map((e) {
                return ListTile(
                  title: Text(e.name),
                  subtitle: Text(e.addr),
                  trailing: Text(e.remainStat ?? ''),
                );
              }).toList(),
            ),
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Column(
        children: [
          Text('정보를 가져오는 중'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
