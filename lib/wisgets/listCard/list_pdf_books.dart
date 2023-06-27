import 'dart:io';

import 'package:bobok/models/pdf.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/pages/view_pdf.dart';
import 'package:bobok/wisgets/card/profile_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListCardPdf extends StatefulWidget {
  const ListCardPdf({super.key});

  @override
  State<ListCardPdf> createState() => _ListCardPdfState();
}

class _ListCardPdfState extends State<ListCardPdf> {
  final user = FirebaseAuth.instance.currentUser!;

  void openPDF(File pdfFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(pdfFile: pdfFile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pdfs')
          .where('uid', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Text('Error');
        }

        final pdfs =
            snapshot.data!.docs.map((doc) => Pdf.fromSnap(doc)).toList();

        // ignore: prefer_typing_uninitialized_variables
        final lengthPdf;
        if (pdfs.isNotEmpty) {
          lengthPdf = pdfs.length;
        } else {
          lengthPdf = 0;
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: lengthPdf,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(pdfs[index].listPdf[0]!.split('/').last),
              onTap: () => {openPDF(File(pdfs[index].listPdf[0]))},
            );
          },
        );
      },
    );
  }
}
