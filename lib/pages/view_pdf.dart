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
  // @override
  // void dispose() {
  //   _pdfViewController
  //       .dispose(); // Lembre-se de liberar o controller quando não for mais necessário.
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PdfViewer.openFile(
        widget.pdfFile.path,
      ),
    );
  }
}
