import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tinh/const/colors_conts.dart';
import 'package:tinh/store/main/main_store.dart';

void showSearchFilterDialog(BuildContext context, MainStore mainStore) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 500),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
          alignment: Alignment.center,
          child: SearchFilterDialog(
            mainStore: mainStore,
          ));
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}

class SearchFilterDialog extends StatelessWidget {
  final MainStore mainStore;
  const SearchFilterDialog({Key? key, required this.mainStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      Color _radioColor(Set<MaterialState> states) {
        return ColorsConts.primaryColor;
      }

      return Material(
        color: Colors.transparent,
        child: Container(
          height: 300,
          child: SizedBox.expand(
              child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    'តើអ្នកចង់ស្វែងរកទំនិញតាមវិធីណា ?',
                    style: TextStyle(fontSize: 18, color: ColorsConts.primaryColor),
                  ),
                ),
                Column(
                  children: <Widget>[
                    for (int i = 1; i <= 2; i++)
                      ListTile(
                        title: Text(i == 1 ? 'ស្វែងរកតាមឈ្មោះទំនិញ' : 'ស្វែងរកតាមប្រភេទទំនិញ'),
                        leading: Radio(
                          fillColor: MaterialStateProperty.resolveWith(_radioColor),
                          value: i,
                          groupValue: mainStore.searchFilterStore.radioValue,
                          activeColor: Color(0xFF6200EE),
                          onChanged: ((int? val) {
                            mainStore.searchFilterStore.changeRadioValue(val!);
                          }),
                        ),
                      ),
                  ],
                )
              ],
            ),
          )),
          margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    });
  }
}
