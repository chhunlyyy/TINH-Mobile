import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.id,
    this.productName,
    this.price,
    this.imageIdRef,
    this.discount,
    this.discountDiscs,
    this.images,
  });

  int? id;
  String? productName;
  String? price;
  String? imageIdRef;
  String? discount;
  String? discountDiscs;
  List<String>? images;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        productName: json["productName"],
        price: json["price"],
        imageIdRef: json["imageIdRef"],
        discount: json["discount"] == null ? '0' : json["discount"],
        discountDiscs: json["discountDiscs"],
        images: List<String>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productName": productName,
        "price": price,
        "imageIdRef": imageIdRef,
        "discount": discount,
        "discountDiscs": discountDiscs,
        "images": List<dynamic>.from(images!.map((x) => x)),
      };
}
