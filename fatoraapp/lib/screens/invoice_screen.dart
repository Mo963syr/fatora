import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/customer_provider.dart';
import '../widgets/invoice_template.dart';
import 'add_customer_screen.dart';
import 'invoice_preview_screen.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final parcelsController = TextEditingController();
  final amountController = TextEditingController();
  final notesController = TextEditingController();
  bool cashOnDelivery = false;
  final notesFocusNode = FocusNode();
  final parcelsFocusNode = FocusNode();
  void _resetFieldsOnCustomerChange() {
    setState(() {
      cashOnDelivery = false;
    });

    parcelsController.text = "1";
    amountController.clear();
    notesController.text = "سريع الكسر";
    amountController.text = "لا يوجد";
  }

  @override
  void initState() {
    super.initState();
    parcelsController.text = "1";
    notesController.text = "سريع الكسر";
    // 1) عرّف دالة داخل _InvoiceScreenState
    amountController.text = "لا يوجد";
    notesFocusNode.addListener(() {
      if (notesFocusNode.hasFocus) {
        notesController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: notesController.text.length,
        );
      }
    });
    parcelsFocusNode.addListener(() {
      if (parcelsFocusNode.hasFocus) {
        parcelsController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: parcelsController.text.length,
        );
      }
    });
    Future.microtask(
      () => context.read<CustomerProvider>().fetchCustomers(),
    );
  }

  @override
  void dispose() {
    notesFocusNode.dispose();
    parcelsFocusNode.dispose();
    parcelsController.dispose();
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      // أو جرّب: Color(0xFFEFF6FF) أزرق فاتح
      appBar: AppBar(
        title: const Text("فاتورة"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddCustomerScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  /// اختيار الزبون
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "اختر زبون",
                        border: OutlineInputBorder(),
                      ),
                      dropdownColor: Colors.white,
                      items: provider.customers.map((customer) {
                        return DropdownMenuItem(
                          value: customer,
                          child: Text(customer.fullName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        provider.setSelectedCustomer(value!);
                        _resetFieldsOnCustomerChange();
                      },
                    ),
                  ),

                  if (provider.selectedCustomer != null) ...[
                    /// عدد الطرود
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        focusNode: parcelsFocusNode,
                        controller: parcelsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "عدد الطرود",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// ضد الدفع
                    SwitchListTile(
                      value: cashOnDelivery,
                      onChanged: (v) {
                        setState(() {
                          cashOnDelivery = v;
                          if (cashOnDelivery) {
                            amountController.clear();
                          } else {
                            amountController.text = "لا يوجد";
                          }
                        });
                      },
                      title: const Text("ضد الدفع"),
                      tileColor: Color.fromARGB(255, 234, 126, 126),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 8)),

                    /// قيمة الحوالة
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        enabled: cashOnDelivery,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: cashOnDelivery
                              ? Colors.white
                              : Colors.grey.shade200,
                          labelText: "قيمة الحوالة",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// ملاحظات
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: notesController,
                        focusNode: notesFocusNode,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "ملاحظات",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// زر عرض الفاتورة
                    ElevatedButton(
                      onPressed: () {
                        if (parcelsController.text.isEmpty ||
                            amountController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("يرجى إدخال جميع البيانات"),
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InvoicePreviewScreen(
                              customer: provider.selectedCustomer!,
                              parcels: int.parse(parcelsController.text),
                              cashOnDelivery: cashOnDelivery,
                              amount: double.tryParse(
                                      amountController.text.trim()) ??
                                  0.0,
                              notes: notesController.text,
                            ),
                          ),
                        );
                      },
                      child: const Text("عرض الفاتورة"),
                    ),

                    const SizedBox(height: 20),

                    /// عرض مصغر داخل نفس الشاشة (اختياري)
                    SizedBox(
                      height: 400,
                      child: InvoiceTemplate(
                        customer: provider.selectedCustomer!,
                        parcels: parcelsController.text.isEmpty
                            ? 0
                            : int.parse(parcelsController.text),
                        cashOnDelivery: cashOnDelivery,
                        amount: cashOnDelivery
                            ? double.tryParse(amountController.text) ?? 0
                            : 0,
                        notes: notesController.text,
                      ),
                    ),
                  ]
                ],
              ),
            ),
    );
  }
}
