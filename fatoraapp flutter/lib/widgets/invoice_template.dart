import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class InvoiceTemplate extends StatelessWidget {
  final Customer customer;
  final int parcels;
  final bool cashOnDelivery;
  final double amount;
  final String? notes;

  const InvoiceTemplate({
    super.key,
    required this.customer,
    required this.parcels,
    required this.cashOnDelivery,
    required this.amount,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: const Center(
                    child: Column(
                      children: [
                        Text(
                          "غسان لالا",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            "0991876682 -  قطع تبديل سيارات - دمشق مجمع القدم"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      buildRow("المرسل إليه", customer.fullName),
                      buildRow("العنوان", customer.address),
                      buildRow("الهاتف", customer.phone),
                      Row(
                        children: [
                          Expanded(
                              child:
                                  buildRow("عدد الطرود", parcels.toString())),
                          const SizedBox(width: 16),
                          Expanded(
                            child: buildRow(
                                "ضد الدفع", cashOnDelivery ? "نعم" : "لا"),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "\$",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Text(amount.toStringAsFixed(0),
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          const Text("قيمة الحوالة :",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      if (notes != null && notes!.isNotEmpty)
                        buildRow("ملاحظات", notes!),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _printInvoice,
                          child: const Text("طباعة الفاتورة"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6), // ✅ كان 8 -> خففناها
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title : ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 16, height: 1.15), // ✅ تقليل تباعد السطر
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _printInvoice() async {
    final pdf = pw.Document();

    final ttf =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Amiri-Regular.ttf'));

    // ✅ 30% من طول A4
    final contentHeight = PdfPageFormat.a4.height * 0.30;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(16),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.blue100,
                        border: pw.Border.all(color: PdfColors.blue, width: 2),
                        borderRadius: pw.BorderRadius.circular(10),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text(
                            "غسان لالا",
                            style: pw.TextStyle(
                              font: ttf,
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 3), // ✅ كان 4 -> خففنا
                          pw.Text(
                            "0991876682 -  قطع تبديل سيارات - دمشق مجمع القدم",
                            style: pw.TextStyle(
                                font: ttf, fontSize: 12, lineSpacing: 1),
                            textAlign: pw.TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  pw.SizedBox(height: 8), // ✅ كان 12 -> خففنا

                  // ✅ محتوى الفاتورة ضمن 30% من طول الورقة
                  pw.Container(
                    height: contentHeight,
                    width: double.infinity,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        buildPdfRow("المرسل إليه", customer.fullName, ttf),
                        buildPdfRow("العنوان", customer.address, ttf),
                        buildPdfRow("الهاتف", customer.phone, ttf),

                        pw.Row(
                          children: [
                            pw.Expanded(
                                child: buildPdfRow(
                                    "عدد الطرود", parcels.toString(), ttf)),
                            pw.SizedBox(width: 16), // ✅ كان 20
                            pw.Expanded(
                              child: buildPdfRow("ضد الدفع",
                                  cashOnDelivery ? "نعم" : "لا", ttf),
                            ),
                          ],
                        ),

                        pw.SizedBox(height: 2),

                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              "قيمة الحوالة:",
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(width: 6),
                            pw.Text(
                              amount.toStringAsFixed(0),
                              style: pw.TextStyle(font: ttf, fontSize: 14),
                            ),
                            pw.SizedBox(width: 3),
                            pw.Text(
                              "\$",
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        if (notes != null && notes!.isNotEmpty)
                          buildPdfRow("ملاحظات", notes!, ttf),

                        // ✅ خط منقّط آخر الكتابة فقط
                        pw.SizedBox(height: 10),
                        dottedLine(
                            dashCount: 42,
                            dashWidth: 6,
                            dashGap: 4,
                            thickness: 1),
                      ],
                    ),
                  ),

                  pw.Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  pw.Widget buildPdfRow(String title, String value, pw.Font font) {
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.symmetric(vertical: 3), // ✅ كان 6 -> خففنا
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "$title : ",
            style: pw.TextStyle(
              font: font,
              fontWeight: pw.FontWeight.bold,
              fontSize: 13, // ✅ كان 14 -> خفيف جداً
            ),
          ),
          pw.SizedBox(width: 6), // ✅ كان 8
          pw.Expanded(
            child: pw.Text(
              value,
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                font: font,
                fontSize: 13,
                lineSpacing: 1, // ✅ تقليل تباعد الأسطر داخل النص
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ خط منقّط (داخل PDF)
  pw.Widget dottedLine({
    int dashCount = 40,
    double dashWidth = 6,
    double dashGap = 4,
    double thickness = 1,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: List.generate(dashCount, (_) {
        return pw.Padding(
          padding: pw.EdgeInsets.only(left: dashGap),
          child: pw.Container(
            width: dashWidth,
            height: thickness,
            color: PdfColors.grey700,
          ),
        );
      }),
    );
  }
}
