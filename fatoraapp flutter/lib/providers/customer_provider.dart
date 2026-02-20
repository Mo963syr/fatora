import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import '../services/customer_api_service.dart';

class CustomerProvider extends ChangeNotifier {
  final api = CustomerApiService();

  List<Customer> customers = [];
  Customer? selectedCustomer;
  bool isLoading = false;

  Future<void> fetchCustomers() async {
    isLoading = true;
    notifyListeners();
    customers = await api.getAll();
    isLoading = false;
    notifyListeners();
  }
void setSelectedCustomer(Customer customer) {
  selectedCustomer = customer;
  notifyListeners();
}

  Future<void> selectByName(String name) async {
    selectedCustomer = await api.getByName(name);
    notifyListeners();
  }

  Future<void> addCustomer(Customer customer) async {
    await api.create(customer);
    await fetchCustomers();
  }
}
