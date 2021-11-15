import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.names,
    required this.descs,
    required this.createAt,
    required this.modifiedAt,
    required this.deleetedAt,
    required this.imageIdRef,
    required this.images,
  });

  int id;
  String names;
  String descs;
  DateTime createAt;
  DateTime modifiedAt;
  DateTime deleetedAt;
  String imageIdRef;
  List<String> images;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        names: json["names"],
        descs: json["descs"],
        createAt: DateTime.parse(json["create_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
        deleetedAt: DateTime.parse(json["deleeted_at"]),
        imageIdRef: json["image_id_ref"],
        images: List<String>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "names": names,
        "descs": descs,
        "create_at": createAt.toIso8601String(),
        "modified_at": modifiedAt.toIso8601String(),
        "deleeted_at": deleetedAt.toIso8601String(),
        "image_id_ref": imageIdRef,
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}
