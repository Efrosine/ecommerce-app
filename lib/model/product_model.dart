class ProductModel {
  final int? id;
  final String? name;
  final int? price;
  final int? stock;
  int? quantity;

  ProductModel({this.id, this.name, this.price, this.stock, this.quantity});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'quantity': quantity,
    };
  }
}
