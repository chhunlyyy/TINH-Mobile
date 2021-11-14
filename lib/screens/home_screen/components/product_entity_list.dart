import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:tinh/helper/widget_helper.dart';
import 'package:tinh/models/product/product_model.dart';
import 'package:tinh/store/product/product_store.dart';

/*
 * EntityListWidget
 */
class ProductEntityListWidget extends StatefulWidget {
  final Widget Function(BuildContext context, dynamic model) itemBuilder;
  final ProductStore store;
  final Map<String, dynamic>? defaultParams;
  final int pageSize;
  final bool isGridView;

  ProductEntityListWidget({
    required this.itemBuilder,
    required this.store,
    this.defaultParams,
    this.pageSize = 10,
    this.isGridView = false,
  });

  @override
  ProductEntityListWidgetState createState() => ProductEntityListWidgetState();
}

/*
 * EntityListWidgetState
 */
class ProductEntityListWidgetState extends State<ProductEntityListWidget> {
  int pageIndex = 0;
  int pageSize = 10;
  @override
  void initState() {
    widget.store.loadData(pageIndex: pageIndex, pageSize: pageSize);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      Widget content = Container();
      final list = widget.store.observableFutureProduct!;

      if (list.value == null) {
        content = WidgetHelper.loadingWidget(context);
      } else {
        content = EasyRefresh(
          header: BallPulseHeader(color: Theme.of(context).primaryColor),
          footer: BallPulseFooter(color: Theme.of(context).primaryColor),
          onRefresh: () async {
            widget.store.loadData(pageIndex: 0, pageSize: 10);
          },
          onLoad: () async {
            widget.store.loadData(pageIndex: pageIndex += 1, pageSize: 10); // increase pages
          },
          child: (list.value!.isNotEmpty) ? _buildContent() : Container(),
        );
      }

      return content;
    });
  }

  Widget _buildContent() {
    if (widget.isGridView) {
      return _gridViewContent();
    }
    return _listViewContent();
  }

  Widget _gridViewContent() {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(1.0),
      childAspectRatio: 8.0 / 12.0,
      children: List<Widget>.generate(widget.store.observableFutureProduct!.value!.length, (index) {
        return GridTile(child: widget.itemBuilder(context, widget.store.observableFutureProduct!.value![index]));
      }),
    );
  }

  Widget _listViewContent() {
    return ListView.builder(
        itemCount: widget.store.observableFutureProduct!.value!.length,
        itemBuilder: (context, index) {
          return widget.itemBuilder(context, widget.store.observableFutureProduct!.value![index]);
        });
  }
}
