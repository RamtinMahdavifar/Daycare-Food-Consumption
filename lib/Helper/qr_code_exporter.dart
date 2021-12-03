import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// class exportQrCodeToPDF {
  Future<void> exportQrCode(String filePath, int studentCount) async {
    ///It generates QR codes for the given student ids
    ///and export it a pdf file
    ///PreCond: Non-null and non-empty file path and Student count which is the total number of students
    ///PostCond: QR codes are generated for all the given student ids and stored in a PDF file
    final pdf = pw.Document();
    for (int i = 0; i < studentCount; i++) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(
            child: pw.BarcodeWidget(
              textStyle: pw.TextStyle(fontSize: 40),
              color: PdfColor.fromHex("#000000"),
              barcode: pw.Barcode.qrCode(),
              data: "ID " + i.toString(),
              drawText: true,
              textPadding: 10,
            ),
          ),
        ),
      );
    }

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
  }
// }