import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/customer_model.dart';
import '../widgets/invoice_template.dart';

class InvoicePreviewScreen extends StatelessWidget {
  final Customer customer;
  final int parcels;
  final bool cashOnDelivery;
  final double amount;
  final String? notes;

  const InvoicePreviewScreen({
    super.key,
    required this.customer,
    required this.parcels,
    required this.cashOnDelivery,
    required this.amount,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      appBar: AppBar(
        title: const Text("معاينة الفاتورة"),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _printInvoice(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: InvoiceTemplate(
          customer: customer,
          parcels: parcels,
          cashOnDelivery: cashOnDelivery,
          amount: amount,
          notes: notes,
        ),
      ),
    );
  }

  Future<void> _printInvoice() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text("فاتورة", style: const pw.TextStyle(fontSize: 22)),
                pw.SizedBox(height: 20),
                pw.Text("المرسل إليه: ${customer.fullName}"),
                pw.Text("العنوان: ${customer.address}"),
                pw.Text("الهاتف: ${customer.phone}"),
                pw.Text("عدد الطرود: $parcels"),
                pw.Text("ضد الدفع: ${cashOnDelivery ? "نعم" : "لا"}"),
                pw.Text("قيمة الحوالة: $amount"),
                if (notes != null && notes!.isNotEmpty)
                  pw.Text("ملاحظات: $notes"),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}
