// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

import 'package:tinh/models/phone_product/phone_product_model.dart';

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
  ImageModel images;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
        id: json["id"],
        name: json["name"],
        imageIdRef: json["image_id_ref"],
        images: ImageModel.fromJson(json["images"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_id_ref": imageIdRef,
        "images": images.toJson(),
      };
}

class Images {
  Images({
    required this.id,
    required this.image,
  });

  int id;
  String image;

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        id: json["id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}
