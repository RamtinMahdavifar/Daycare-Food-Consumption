import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class exportQrCodeToPDF{

  Future<void> exportQrcode(String filePath, int studentCount) async {
    //It generates QR codes for the given student ids
    //and export it a pdf file
    //PreCond: Non-null and non-empty file path and Student count which is the total number of students
    //PostCond: QR codes are generated for all the given student ids and stored in a PDF file
    final pdf = pw.Document();
    for(int i=0;i<studentCount;i++){

      pdf.addPage(

        pw.Page(

          build: (pw.Context context) => pw.Center(
            child: pw.BarcodeWidget(
              textStyle: pw.TextStyle(fontSize: 40),
              color: PdfColor.fromHex("#000000"),
              barcode: pw.Barcode.qrCode(),
              data: "ID "+i.toString(),
              drawText: true,
              textPadding: 10,

            ) ,
          ),
        ),
      );
    }


    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
  }

}





// Future<void> main() async {
//   final pdf = pw.Document();
//   for(int i=0;i<20;i++) {
//     String qr = 'id '+i.toString();
//
//     final qrValidationResult = QrValidator.validate(
//       data: qr,
//       version: QrVersions.auto,
//       errorCorrectionLevel: QrErrorCorrectLevel.L,
//     );
//
//     final qrCode = qrValidationResult.qrCode;
//
//     final painter = QrPainter.withQr(
//       qr: qrCode as QrCode,
//       // color: const Color(0xFF000000),
//       gapless: true,
//       embeddedImageStyle: null,
//       embeddedImage: null,
//     );
//
//
//     pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         margin: pw.EdgeInsets.all(32),
//         build: (pw.Context context) {
//           return <pw.Widget>[
//             pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.center,
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: <pw.Widget>[
//                   pw.ClipRect(
//                     child: pw.Container(
//
//                       child: pw.CustomPaint(painter: painter as pw.CustomPainter)
//                     ),
//                   ),
//                 ]),
//             pw.ClipRect(
//               child: pw.Container(
//                 child: pw.Text("id "+i.toString()),
//               ),
//             )
//           ];
//         }));
//   }
//   final file = File('example.pdf');
//   await file.writeAsBytes(await pdf.save());
// }
//
// import 'dart:io';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
//
//

