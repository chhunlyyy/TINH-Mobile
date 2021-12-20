// To parse this JSON data, do
//
//     final phoneProductModel = phoneProductModelFromJson(jsonString);

import 'dart:convert';

PhoneProductModel phoneProductModelFromJson(String str) => PhoneProductModel.fromJson(json.decode(str));

String phoneProductModelToJson(PhoneProductModel data) => json.encode(data.toJson());

class PhoneProductModel {
  PhoneProductModel({
    required this.isNew,
    required this.id,
    required this.name,
    required this.isWarranty,
    required this.warrantyPeriod,
    required this.imageIdRef,
    required this.categoryId,
    required this.brandId,
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
  List<String> images;
  List<String> colors;
  List<Detail> detail;
  List<Storage> storage;

  factory PhoneProductModel.fromJson(Map<String, dynamic> json) => PhoneProductModel(
        id: json["id"],
        name: json["name"],
        isWarranty: json["is_warranty"],
        isNew: json["is_new"],
        warrantyPeriod: json["warranty_period"],
        imageIdRef: json["image_id_ref"],
        categoryId: json["category_id"],
        brandId: json["brand_id"],
        images: List<String>.from(json["images"].map((x) => x)),
        colors: List<String>.from(json["colors"].map((x) => x)),
        detail: List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
        storage: List<Storage>.from(json["storage"].map((x) => Storage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_warranty": isWarranty,
        "is_new": isNew,
        "warranty_period": warrantyPeriod,
        "image_id_ref": imageIdRef,
        "category_id": categoryId,
        "brand_id": brandId,
        "images": List<dynamic>.from(images.map((x) => x)),
        "colors": List<dynamic>.from(colors.map((x) => x)),
        "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
        "storage": List<dynamic>.from(storage.map((x) => x.toJson())),
      };
}

class Detail {
  Detail({
    required this.name,
    required this.descs,
  });

  String name;
  String descs;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        name: json["name"],
        descs: json["descs"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "descs": descs,
      };
}

class Storage {
  Storage({
    required this.storage,
    required this.price,
    required this.discount,
    required this.priceAfterDiscount,
  });

  int storage;
  int price;
  int discount;
  int priceAfterDiscount;

  factory Storage.fromJson(Map<String, dynamic> json) => Storage(
        storage: json["storage"],
        price: json["price"],
        discount: json["discount"],
        priceAfterDiscount: json["price_after_discount"],
      );

  Map<String, dynamic> toJson() => {
        "storage": storage,
        "price": price,
        "discount": discount,
        "price_after_discount": priceAfterDiscount,
      };
}
