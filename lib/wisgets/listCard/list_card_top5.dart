import 'dart:io';
import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/wisgets/card/card_top5.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListCardTop5 extends StatefulWidget {
  const ListCardTop5(
      {super.key, required this.uid, this.userStore, required this.userId});
  final String? uid;
  final String? userId;
  final UserStore? userStore;

  @override
  State<ListCardTop5> createState() => _ListCardTop5State();
}

class _ListCardTop5State extends State<ListCardTop5> {
  late Future<List<QueryDocumentSnapshot>> _reviewsTop;
  String systemLanguagePrefix() {
    final locale = Platform.localeName;
    return locale.substring(0, 2);
  }

  Future<void> getTop5En() async {
    // Consulta para obter os top 5 documentos
    var reviewsSnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('language', isLessThan: 'enz')
        .orderBy('language')
        .orderBy('likes', descending: true)
        .limit(5)
        .get();
    // Referência para a nova coleção 'top5en'
    CollectionReference top5EnCollection =
        FirebaseFirestore.instance.collection('top5en');

    // Iterar sobre os documentos e adicioná-los à nova coleção
    reviewsSnapshot.docs.forEach((doc) {
      // Adiciona o documento à coleção 'top5en'
      top5EnCollection.add(doc.data());
    });
  }

  Future<List<QueryDocumentSnapshot>> getTop5() async {
    //getTop5En();
    // Obtendo as reviews dos amigos
    if (systemLanguagePrefix() == 'pt') {
      var reviewsSnapshot =
          await FirebaseFirestore.instance.collection('top5pt').get();
      return reviewsSnapshot.docs;
    } else {
      var reviewsSnapshot =
          await FirebaseFirestore.instance.collection('top5en').get();
      return reviewsSnapshot.docs;
    }
  }

  @override
  Widget build(BuildContext context) {
    _reviewsTop = getTop5();
    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: _reviewsTop.asStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Text('Error');
        }

        final reviews =
            snapshot.data!.map((doc) => Review.fromSnap(doc)).toList();

        // Ordenar as revisões com base na contagem de likes
        reviews.sort((a, b) => b.likes.length.compareTo(a.likes.length));

        // Pegar as 5 primeiras revisões
        final top5Reviews = reviews.take(5).toList();

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: SizedBox(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: top5Reviews.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: (2.8 / 4),
                  crossAxisCount: 1,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (ctx, i) {
                  return CardTop5(
                    itemReview: top5Reviews[i],
                    userId: widget.userId,
                    uid: widget.uid,
                    userStore: widget.userStore,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
