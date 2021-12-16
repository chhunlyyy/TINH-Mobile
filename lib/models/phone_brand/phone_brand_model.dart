import 'dart:convert';

PhoneBrandModel phoneBrandFromJson(String str) => PhoneBrandModel.fromJson(json.decode(str));

String phoneBrandToJson(PhoneBrandModel data) => json.encode(data.toJson());

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
  List<String> images;

  factory PhoneBrandModel.fromJson(Map<String, dynamic> json) => PhoneBrandModel(
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
