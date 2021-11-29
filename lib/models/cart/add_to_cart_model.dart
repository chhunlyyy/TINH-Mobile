class AddToCartModel {
  AddToCartModel({
    required this.productId,
    required this.productName,
    required this.productColor,
    required this.productPrice,
    required this.total,
    required this.amount,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.imageBase64String,
    required this.productSize,
  });

  String productId;
  String productName;
  String productColor;
  String productPrice;
  String productSize;
  String total;
  String amount;
  String userId;
  String userName;
  String userPhone;
  String imageBase64String;

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'product_name': productName,
        'product_color': productColor,
        'product_price': productPrice,
        'total': total,
        'amount': amount,
        'user_id': userId,
        'user_name': userName,
        'product_size': productSize,
        'user_phone': userPhone,
        'image_base64_String': imageBase64String,
      };
}
