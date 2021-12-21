import 'dart:convert';

CategoriesModel categoriesModelFromJson(String str) => CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel data) => json.encode(data.toJson());

class CategoriesModel {
  CategoriesModel({
    required this.id,
    required this.name,
    required this.imageIdRef,
    required this.images,
  });

  int id;
  String name;
  String imageIdRef;
  List<String> images;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
        id: json["id"],
        name: json["name"],
        imageIdRef: json["image_id_ref"],
        images: List<String>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_id_ref": imageIdRef,
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}
