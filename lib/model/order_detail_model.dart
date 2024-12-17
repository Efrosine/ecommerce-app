import 'package:ecommerce/model/product_model.dart';

class OrderDetailModel {
  final int? id;
  final int? quantity;
  final ProductModel? product;

  OrderDetailModel({this.id, this.quantity, this.product});

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'],
      quantity: json['quantity'],
      product: ProductModel.fromJson(json['product']),
    );
  }
}
