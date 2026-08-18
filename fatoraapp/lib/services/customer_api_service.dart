import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../models/customer_model.dart';

class CustomerApiService {
  final String base = "${ApiConfig.baseUrl}/customers";

  Future<List<Customer>> getAll() async {
    final res = await http.get(Uri.parse(base));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Customer.fromJson(e)).toList();
    }
    throw Exception("Failed to load customers");
  }

  Future<Customer> getByName(String name) async {
    final res = await http.get(
      Uri.parse("$base/by-name?fullName=$name"),
    );
    if (res.statusCode == 200) {
      return Customer.fromJson(jsonDecode(res.body));
    }
    throw Exception("Customer not found");
  }

  Future<void> create(Customer customer) async {
    final res = await http.post(
      Uri.parse(base),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(customer.toJson()),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception("Create failed");
    }
  }
}
