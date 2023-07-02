import 'dart:io';
import 'dart:typed_data';

import 'package:bobok/data/dummy_data.dart';
import 'package:bobok/models/pdf.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/pages/view_pdf.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/wisgets/card/profile_review.dart';
import 'package:bobok/wisgets/listCard/list_pdf_books.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class Books extends StatefulWidget {
  const Books({super.key, required this.uid});
  final String uid;

  @override
  _BooksState createState() => _BooksState();
}

class _BooksState extends State<Books> {
  List<String> cards = ['Card 2', 'Card 1', 'Card 3'];
  final List<Review> loadedReviewUser = dummyReviws;

  File? pdf;
  String filePath = '';
  int selectedIndex = 1;
  var listPdf;

  @override
  void initState() {
    super.initState();
    getListPdf(0);
  }

  void getListPdf(int index) async {
    var listPdfs = await FirebaseFirestore.instance
        .collection('pdfs')
        .where('uid', isEqualTo: widget.uid)
        .get();
    final pdfs = listPdfs.docs.map((doc) => Pdf.fromSnap(doc)).toList();

    setState(() {
      listPdf = listPdfs.docs.length;
      if (pdfs.isNotEmpty) {
        filePath = pdfs[index].listPdf[index];
      }
    });
  }

  void pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File pdfFile = File(result.files.single.path!);
      openPDF(pdfFile);
      FirestoreMethods().addListPdf(result.files.single.path!, listPdf);

      // Faça algo com o arquivo PDF selecionado, como abrir ou salvar em uma lista de acesso rápido.
    } else {
      // Nenhum arquivo foi selecionado.
    }
  }

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
    return Scaffold(
      body: Column(
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 150,
                width: 110,
                child: Stack(
                  children: [
                    Container(
                      height: 150,
                      padding: const EdgeInsets.all(4), // Border width
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: SizedBox.fromSize(
                            size: const Size.fromRadius(48), // Image radius
                            child: filePath.isEmpty
                                ? IconButton(
                                    padding: const EdgeInsets.all(0),
                                    icon: Icon(
                                      Icons.book,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      size: 80,
                                    ),
                                    onPressed: () {
                                      pickPDF();
                                    },
                                  )
                                : PdfDocumentLoader.openFile(filePath,
                                    pageNumber: 1,
                                    pageBuilder:
                                        (context, textureBuilder, pageSize) =>
                                            textureBuilder())),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: RawMaterialButton(
                            onPressed: () {},
                            elevation: 2.0,
                            fillColor: Theme.of(context).colorScheme.background,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: Icon(
                                Icons.note_add,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                pickPDF();
                              },
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: 150,
            //   width: deviceWidth,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: ListCardPdf(),
            //   ),
            // )
            Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
              SizedBox(height: 150, child: ListCardPdf())
            ])))
          ]),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                children: [
                  const Text("Resenhas"),
                  Expanded(
                    child: SizedBox(
                      child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: loadedReviewUser.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: (2.8 / 4),
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2),
                          itemBuilder: (ctx, i) =>
                              ProfileReview(itemReview: loadedReviewUser[i])),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(int index, Offset offset) {
    return Draggable(
      data: index,
      feedback: Card(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Container(
              width: 100,
              height: 200,
              child: Center(
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: Icon(
                    Icons.note_add,
                    color: Theme.of(context).colorScheme.primary,
                    size: 80,
                  ),
                  onPressed: () {
                    pickPDF();
                  },
                ),
              )),
        ),
      ),
      childWhenDragging: Container(),
      onDragEnd: (details) {
        print(index);
        setState(() {
          final draggedCard = cards.removeAt(index);
          cards.insert(selectedIndex, draggedCard);
        });
      },
      child: Opacity(
        opacity: selectedIndex == index ? 1.0 : 0.7,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
                width: 100,
                height: 200,
                child: Center(
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: Icon(
                      Icons.note_add,
                      color: Theme.of(context).colorScheme.primary,
                      size: 40,
                    ),
                    onPressed: () {
                      pickPDF();
                    },
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
