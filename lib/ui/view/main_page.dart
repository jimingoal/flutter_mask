import 'package:flutter_mask/viewmodel/store_model.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../model/store.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storeModel = Provider.of<StoreModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('마스크 재고 있는곳: ${storeModel.stores.where((e) {
          return e.remainStat == 'plenty' ||
              e.remainStat == 'some' ||
              e.remainStat == 'few';
        }).length}'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                storeModel.fetch();
              })
        ],
      ),
      body: Center(
        child: storeModel.isLoading
            ? loadingWidget()
            : ListView(
                children: storeModel.stores.where((e) {
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
