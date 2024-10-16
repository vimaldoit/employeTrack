import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class Viewpdf extends StatelessWidget {
  const Viewpdf({super.key});

  pw.Widget PaddedText(
    final String text, {
    final pw.TextAlign align = pw.TextAlign.left,
  }) =>
      pw.Padding(
        padding: pw.EdgeInsets.all(10),
        child: pw.Text(
          text,
          textAlign: align,
        ),
      );
  Future<Uint8List> makePdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(build: (context) {
      pageFormat:
      PdfPageFormat.a4;
      return <pw.Widget>[
        pw.Padding(
          child: pw.Text(
            'INVOICE FOR PAYMENT',
            style: pw.Theme.of(context).header4,
            textAlign: pw.TextAlign.center,
          ),
          padding: pw.EdgeInsets.all(20),
        ),
        pw.Table(border: pw.TableBorder.all(color: PdfColors.black), children: [
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
          pw.TableRow(
            children: [
              pw.Expanded(child: PaddedText("name"), flex: 2),
              pw.Expanded(child: PaddedText("vimal"), flex: 1)
            ],
          ),
        ])
      ];
    }));
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        build: (context) => makePdf(),
      ),
    );
  }
}
