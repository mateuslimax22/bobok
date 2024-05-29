import 'package:cloud_firestore/cloud_firestore.dart';

class Pdf {
  final String? uid;
  final String? pdfsId;
  final listPdf;

  Pdf({
    this.uid,
    this.pdfsId,
    this.listPdf,
  });

  static Pdf fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Pdf(
        uid: snapshot['uid'],
        pdfsId: snapshot['pdfsId'],
        listPdf: snapshot['listPdf']);
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "pdfsId": pdfsId,
        "listPdf": listPdf,
      };
}
