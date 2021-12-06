import 'dart:convert';
import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:plate_waste_recorder/Model/database.dart';
import 'package:plate_waste_recorder/Model/institution.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';

Future<void> exportQrCode(String filePath, InstitutionInfo currentInstitution) async {
  ///It generates QR codes for the given student ids
  ///and export it a pdf file
  ///PreCond: Non-null and non-empty file path and Student count which is the total number of students
  ///PostCond: QR codes are generated for all the given student ids and stored in a PDF file

  // read in the subjects for the input institution off the database

  await Database().getInstitutionData(currentInstitution, ResearchGroupInfo("testResearchGroupName")).then((dataSnapshot) async {

    // generate our pdf using this data
    if(dataSnapshot.value==null){
      // we have no data for this institution
    }
    else{
      // we have data for the specified input institution
      Map<dynamic, dynamic> snapshotValueMap = dataSnapshot.value as Map<dynamic,dynamic>;
      String encodedMap = jsonEncode(snapshotValueMap);
      Map<String, dynamic> institutionJSON = json.decode(
          encodedMap) as Map<String,dynamic>;
      // convert our read in JSON to an Institution object, add the subjects of this institution
      // to our pdf
      Institution retrievedInstitution = Institution.fromJSON(institutionJSON);
      Map<String, SubjectInfo> subjectsMap = retrievedInstitution.subjectsMap;

      if(subjectsMap.isEmpty){
        // we don't have any subjects for this particular institution
      }
      else{
        // we do have subjects for this institution, add the id and qr code for each
        // subject to our resulting pdf, display these in sorted order
        List<String> sortedSubjectIDs = retrievedInstitution.subjectsMap.keys.toList();
        sortedSubjectIDs.sort();

        final pdf = pw.Document();
        sortedSubjectIDs.forEach((subjectID) {
          pdf.addPage(
            pw.Page(
              build: (pw.Context context) => pw.Center(
                child: pw.BarcodeWidget(
                  textStyle: pw.TextStyle(fontSize: 40),
                  color: PdfColor.fromHex("#000000"),
                  barcode: pw.Barcode.qrCode(),
                  data: subjectID,
                  drawText: true,
                  textPadding: 10,
                ),
              ),
            ),
          );
        });

        final file = File(filePath);
        await file.writeAsBytes(await pdf.save());
    }
  }});
}
