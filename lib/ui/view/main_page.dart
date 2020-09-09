import 'package:flutter/material.dart';
import 'package:flutter_mask/ui/widget/remain_stat_list_tile.dart';
import 'package:flutter_mask/viewmodel/store_model.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storeModel = Provider.of<StoreModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('마스크 재고 있는곳: ${storeModel.stores.length}'),
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
                children: storeModel.stores.map((e) {
                  return RemainStatListTile(e);
                }).toList(),
              ),
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
