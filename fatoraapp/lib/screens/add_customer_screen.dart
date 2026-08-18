import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/customer_model.dart';
import '../providers/customer_provider.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

  final nameFocus = FocusNode();
  final phoneFocus = FocusNode();
  final addressFocus = FocusNode();
  // 1) خزّن زر "حفظ" بدالة وKey (حتى نقدر ننفّذه من Enter)
  final _formKey = GlobalKey<FormState>();

  Future<void> _save(CustomerProvider provider) async {
    await provider.addCustomer(
      Customer(
        id: "",
        fullName: name.text,
        phone: phone.text,
        address: address.text,
      ),
    );
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameFocus.dispose();
    phoneFocus.dispose();
    addressFocus.dispose();
    name.dispose();
    phone.dispose();
    address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CustomerProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      appBar: AppBar(title: const Text("إضافة زبون")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: name,
                focusNode: nameFocus,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(phoneFocus);
                },
                decoration: const InputDecoration(
                  labelText: "الاسم",
                  filled: true,
                  fillColor: Colors.white,
                )),
            Padding(padding: const EdgeInsets.symmetric(vertical: 8)),
            TextField(
                controller: phone,
                focusNode: phoneFocus,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(addressFocus);
                },
                decoration: const InputDecoration(
                  labelText: "الهاتف",
                  filled: true,
                  fillColor: Colors.white,
                )),
            Padding(padding: const EdgeInsets.symmetric(vertical: 8)),
            // 2) داخل build: استعمل onSubmitted بحقل العنوان ليضغط حفظ
            TextField(
              controller: address,
              focusNode: addressFocus,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(provider), // ✅ Enter هنا = حفظ
              decoration: const InputDecoration(
                labelText: "العنوان",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 16)),
            ElevatedButton(
              onPressed: () => _save(provider),
              child: const Text("حفظ"),
            )
          ],
        ),
      ),
    );
  }
}
