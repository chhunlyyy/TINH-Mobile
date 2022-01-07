// To parse this JSON data, do
//
//     final phoneBrandModel = phoneBrandModelFromJson(jsonString);

import 'dart:convert';

import 'package:tinh/models/phone_product/phone_product_model.dart';

PhoneBrandModel phoneBrandModelFromJson(String str) => PhoneBrandModel.fromJson(json.decode(str));

String phoneBrandModelToJson(PhoneBrandModel data) => json.encode(data.toJson());

class PhoneBrandModel {
  PhoneBrandModel({
    required this.id,
    required this.name,
    required this.imageIdRef,
    required this.images,
  });

  int id;
  String name;
  String imageIdRef;
  ImageModel images;

  factory PhoneBrandModel.fromJson(Map<String, dynamic> json) => PhoneBrandModel(
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
