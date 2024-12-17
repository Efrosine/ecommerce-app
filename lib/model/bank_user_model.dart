class BankUserModel {
  final int? id;
  final String? name;
  final String? email;
  final int? balance;

  BankUserModel({this.id, this.name, this.email, this.balance});

  factory BankUserModel.fromJson(Map<String, dynamic> json) {
    return BankUserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      balance: json['balance'],
    );
  }
}
