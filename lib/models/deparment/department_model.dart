import 'dart:convert';

DepartmentModel departmentFromJson(String str) => DepartmentModel.fromJson(json.decode(str));

String departmentToJson(DepartmentModel data) => json.encode(data.toJson());

class DepartmentModel {
  DepartmentModel({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  dynamic image;
  DateTime createdAt;
  DateTime updatedAt;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) => DepartmentModel(
        id: json["id"] != null ? json["id"] : null,
        name: json["name"] != null ? json["name"] : null,
        image: json["image"] != null ? json["image"] : null,
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
