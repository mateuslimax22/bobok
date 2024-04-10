import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuickAccessList extends StatefulWidget {
  const QuickAccessList({super.key, required this.uid});
  final String uid;

  @override
  State<QuickAccessList> createState() => _QuickAccessListState();
}

class _QuickAccessListState extends State<QuickAccessList> {
  final List<File> _pdfFiles = [];

  @override
  void initState() {
    super.initState();
  }

  void getListPdf() async {
    var listPdfs = await FirebaseFirestore.instance
        .collection('pdfs')
        .doc(widget.uid)
        .get();
    print(listPdfs);
    // setState(() {
    //   listPdf = listPdfs;
    // });
  }

  void addPDF(File pdfFile) {
    _pdfFiles.add(pdfFile);
  }

  void removePDF(File pdfFile) {
    _pdfFiles.remove(pdfFile);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
