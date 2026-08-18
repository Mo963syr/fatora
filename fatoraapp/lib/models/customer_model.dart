class Customer {
  final String id;
  final String fullName;
  final String phone;
  final String address;

  Customer({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "phone": phone,
      "address": address,
    };
  }
}
