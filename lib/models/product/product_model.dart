import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel(
      {required this.id,
      required this.productName,
      required this.price,
      required this.imageIdRef,
      required this.discount,
      required this.discountDiscs,
      required this.images,
      required this.colors,
      required this.size,
      required this.desc});

  int id;
  String productName;
  String price;
  String imageIdRef;
  String discount;
  String desc;
  String discountDiscs;
  List<String> images;
  List<String> colors;
  List<String> size;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        productName: json["productName"],
        price: json["price"],
        imageIdRef: json["imageIdRef"],
        desc: json['desc'],
        discount: json["discount"],
        discountDiscs: json["discountDiscs"],
        images: List<String>.from(json["images"].map((x) => x)),
        colors: List<String>.from(json["colors"].map((x) => x)),
        size: List<String>.from(json["size"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productName": productName,
        'desc': desc,
        "price": price,
        "imageIdRef": imageIdRef,
        "discount": discount,
        "discountDiscs": discountDiscs,
        "images": List<dynamic>.from(images.map((x) => x)),
        "colors": List<dynamic>.from(colors.map((x) => x)),
        "size": List<dynamic>.from(size.map((x) => x)),
      };
}
