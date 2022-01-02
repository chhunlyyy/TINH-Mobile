// To parse this JSON data, do
//
//     final phoneProductModel = phoneProductModelFromJson(jsonString);

import 'dart:convert';

PhoneProductModel phoneProductModelFromJson(String str) => PhoneProductModel.fromJson(json.decode(str));

String phoneProductModelToJson(PhoneProductModel data) => json.encode(data.toJson());

class PhoneProductModel {
  PhoneProductModel({
    required this.id,
    required this.name,
    required this.isWarranty,
    required this.warrantyPeriod,
    required this.imageIdRef,
    required this.categoryId,
    required this.brandId,
    required this.isNew,
    required this.images,
    required this.colors,
    required this.detail,
    required this.storage,
  });

  int id;
  String name;
  int isWarranty;
  String warrantyPeriod;
  String imageIdRef;
  int categoryId;
  int brandId;
  int isNew;
  List<Image> images;
  List<Color> colors;
  List<Detail> detail;
  List<Storage> storage;

  factory PhoneProductModel.fromJson(Map<String, dynamic> json) => PhoneProductModel(
        id: json["id"],
        name: json["name"],
        isWarranty: json["is_warranty"],
        warrantyPeriod: json["warranty_period"],
        imageIdRef: json["image_id_ref"],
        categoryId: json["category_id"],
        brandId: json["brand_id"],
        isNew: json["is_new"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        colors: List<Color>.from(json["colors"].map((x) => Color.fromJson(x))),
        detail: List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
        storage: List<Storage>.from(json["storage"].map((x) => Storage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_warranty": isWarranty,
        "warranty_period": warrantyPeriod,
        "image_id_ref": imageIdRef,
        "category_id": categoryId,
        "brand_id": brandId,
        "is_new": isNew,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "colors": List<dynamic>.from(colors.map((x) => x.toJson())),
        "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
        "storage": List<dynamic>.from(storage.map((x) => x.toJson())),
      };
}

class Color {
  Color({
    required this.id,
    required this.color,
  });

  int id;
  String color;

  factory Color.fromJson(Map<String, dynamic> json) => Color(
        id: json["id"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "color": color,
      };
}

class Detail {
  Detail({
    required this.id,
    required this.name,
    required this.descs,
  });

  int id;
  String name;
  String descs;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        name: json["name"],
        descs: json["descs"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "descs": descs,
      };
}

class Image {
  Image({
    required this.id,
    required this.image,
  });

  int id;
  String image;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}

class Storage {
  Storage({
    required this.id,
    required this.storage,
    required this.price,
    required this.discount,
    required this.priceAfterDiscount,
  });

  int id;
  String storage;
  int price;
  int discount;
  int priceAfterDiscount;

  factory Storage.fromJson(Map<String, dynamic> json) => Storage(
        id: json["id"],
        storage: json["storage"],
        price: json["price"],
        discount: json["discount"],
        priceAfterDiscount: json["price_after_discount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "storage": storage,
        "price": price,
        "discount": discount,
        "price_after_discount": priceAfterDiscount,
      };
}
