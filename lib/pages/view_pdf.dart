import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PDFViewerScreen extends StatefulWidget {
  final File pdfFile;

  const PDFViewerScreen({Key? key, required this.pdfFile}) : super(key: key);

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: PdfViewer.openFile(
        widget.pdfFile.path,
      ),
    );
  }
}
