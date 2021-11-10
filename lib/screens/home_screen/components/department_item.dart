import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tinh/models/deparment/department_model.dart';

class DepartmentItem extends StatelessWidget {
  final DepartmentModel departmentModel;
  const DepartmentItem({Key? key, required this.departmentModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                image: DecorationImage(image: MemoryImage(base64Decode(departmentModel.image))),
                color: Color.fromRGBO(255, 236, 223, 1),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            child: Text(
              departmentModel.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
