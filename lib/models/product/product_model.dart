// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.discount,
    required this.priceAfterDiscount,
    required this.isWarranty,
    required this.warrantyPeriod,
    required this.imageIdRef,
    required this.images,
    required this.colors,
    required this.detail,
  });

  int id;
  int categoryId;
  String name;
  int price;
  int discount;
  int priceAfterDiscount;
  int isWarranty;
  String warrantyPeriod;
  String imageIdRef;
  List<String> images;
  List<String> colors;
  List<Detail> detail;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        price: json["price"],
        discount: json["discount"],
        priceAfterDiscount: json["price_after_discount"],
        isWarranty: json["is_warranty"],
        warrantyPeriod: json["warranty_period"],
        imageIdRef: json["image_id_ref"],
        images: List<String>.from(json["images"].map((x) => x)),
        colors: List<String>.from(json["colors"].map((x) => x)),
        detail: List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "price": price,
        "discount": discount,
        "price_after_discount": priceAfterDiscount,
        "is_warranty": isWarranty,
        "warranty_period": warrantyPeriod,
        "image_id_ref": imageIdRef,
        "images": List<dynamic>.from(images.map((x) => x)),
        "colors": List<dynamic>.from(colors.map((x) => x)),
        "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
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
