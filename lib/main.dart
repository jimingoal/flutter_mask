import 'package:flutter/material.dart';
import 'package:flutter_mask/repository/store_repository.dart';
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

  StoreRepository storeRepository = StoreRepository();

  @override
  void initState() {
    super.initState();
    storeRepository.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마스크 재고 있는곳: ${stores.where((e) {
          return e.remainStat == 'plenty' ||
              e.remainStat == 'some' ||
              e.remainStat == 'few';
        }).length}'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                storeRepository.fetch();
              })
        ],
      ),
      body: Center(
        child: isLoading
            ? loadingWidget()
            : ListView(
                children: stores.where((e) {
                  return e.remainStat == 'plenty' ||
                      e.remainStat == 'some' ||
                      e.remainStat == 'few';
                }).map((e) {
                  return ListTile(
                    title: Text(e.name),
                    subtitle: Text(e.addr),
                    trailing: _buildReaminStat(e),
                  );
                }).toList(),
              ),
      ),
    );
  }

  Widget _buildReaminStat(Store store) {
    var remainStat = '판매중지';
    var description = '판매중지';
    var color = Colors.black;

    print(store.remainStat);

    switch (store.remainStat) {
      case 'plenty':
        remainStat = '충분';
        description = '100개 이상';
        color = Colors.green;
        break;
      case 'some':
        remainStat = '보통';
        description = '30 ~ 100개';
        color = Colors.yellow;
        break;
      case 'few':
        remainStat = '부족';
        description = '2 ~ 30개';
        color = Colors.red;
        break;
      case 'empty':
        remainStat = '소진임박';
        description = '1개 이하';
        color = Colors.grey;
        break;
    }

    return Column(
      children: [
        Text(
          remainStat,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          description,
          style: TextStyle(
            color: color,
          ),
        ),
      ],
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
