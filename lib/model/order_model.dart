import 'package:ecommerce/model/order_detail_model.dart';

class OrderModel {
  final int? id;
  final String? orderDate;
  final String? status;
  final int? totalPrice;
  final List<OrderDetailModel>? orderDetails;

  OrderModel({this.id, this.orderDate, this.status, this.totalPrice,this.orderDetails});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderDate: json['order_date'],
      status: json['status'],
      totalPrice: json['total_price'],
      orderDetails: json['order_details'] != null
          ? (json['order_details'] as List)
              .map((detail) => OrderDetailModel.fromJson(detail))
              .toList()
          : null,
    );
  }
}
