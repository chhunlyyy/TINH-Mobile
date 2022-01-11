import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/store/main/main_store.dart';

class ManagementDashboard extends StatefulWidget {
  const ManagementDashboard({Key? key}) : super(key: key);

  @override
  _ManagementDashboardState createState() => _ManagementDashboardState();
}

class _ManagementDashboardState extends State<ManagementDashboard> {
  @override
  Widget build(BuildContext context) {
    final mainStore = Provider.of<MainStore>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConts.primaryColor,
        title: Text('ផ្ទាំងគ្រប់គ្រង'),
      ),
      body: Material(
        child: Container(
          child: Text(mainStore.phoneBrandStore.phoneBrandList[0].name),
        ),
      ),
    );
  }
}
