import 'package:bobok/models/review.dart';
import 'package:bobok/wisgets/card/card_fav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListCardRecommendation extends StatefulWidget {
  const ListCardRecommendation(
      {super.key, required this.uid, required this.userId});
  final String? uid;
  final String? userId;

  @override
  State<ListCardRecommendation> createState() => _ListCardRecommendationState();
}

class _ListCardRecommendationState extends State<ListCardRecommendation> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('favorites')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Exibindo indicador de progresso enquanto os dados são carregados
        }
        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text(
            'Add Indicações',
            textAlign: TextAlign.center,
          );
        }

        // Obtendo IDs de revisões favoritas do snapshot

        List<dynamic> favoriteReviewIds =
            snapshot.data!.docs.map((doc) => doc['reviewId']).toList();

        // Consultando revisões favoritas na coleção "reviews"
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('reviews')
              .where('uid', isEqualTo: widget.uid)
              .where('postId', whereIn: favoriteReviewIds)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> reviewsSnapshot) {
            if (reviewsSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (reviewsSnapshot.hasError) {
              return Text('Erro: ${reviewsSnapshot.error}');
            }
            if (!reviewsSnapshot.hasData ||
                reviewsSnapshot.data!.docs.isEmpty) {
              return const Text('Add Indicações.');
            }

            final reviews = reviewsSnapshot.data!.docs
                .map((doc) => Review.fromSnap(doc))
                .toList();

            // Agora você pode usar reviewsSnapshot para construir sua interface com os dados das revisões favoritas
            // Por exemplo, você pode usar ListView.builder para exibir a lista de revisões.

            return GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: (2.8 / 4),
                    crossAxisCount: 1,
                    mainAxisSpacing: 2),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  // Construa os itens da lista com base nos documentos de revisão favoritos

                  return CardFavorite(
                      itemReview: reviews[index],
                      userId: widget.userId,
                      uid: widget.uid);
                });
          },
        );
      },
    );
  }
}
