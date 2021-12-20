import 'dart:convert';

PhoneCategoryModel phoneCategoryModelFromJson(String str) => PhoneCategoryModel.fromJson(json.decode(str));

String phoneCategoryModelToJson(PhoneCategoryModel data) => json.encode(data.toJson());

class PhoneCategoryModel {
  PhoneCategoryModel({
    required this.id,
    required this.name,
    required this.imageIdRef,
    required this.images,
  });

  int id;
  String name;
  String imageIdRef;
  List<String> images;

  factory PhoneCategoryModel.fromJson(Map<String, dynamic> json) => PhoneCategoryModel(
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
