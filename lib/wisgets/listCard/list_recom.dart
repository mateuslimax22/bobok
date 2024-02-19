import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/wisgets/card/card_fav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListCardRecommendation extends StatefulWidget {
  const ListCardRecommendation(
      {super.key,
      required this.uid,
      required this.userId,
      required this.userStore});
  final String? uid;
  final String? userId;
  final UserStore? userStore;

  @override
  State<ListCardRecommendation> createState() => _ListCardRecommendationState();
}

class _ListCardRecommendationState extends State<ListCardRecommendation>
    with AutomaticKeepAliveClientMixin<ListCardRecommendation> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('favorites')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Exibindo indicador de progresso enquanto os dados são carregados
        }
        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return widget.uid == widget.userId
              ? Text(
                  'Add Indicações',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              : const Text("Sem Indicações");
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
              return const CircularProgressIndicator();
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
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 7,
                ),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  // Construa os itens da lista com base nos documentos de revisão favoritos

                  return CardFavorite(
                    itemReview: reviews[index],
                    userId: widget.userId,
                    uid: widget.uid,
                    userStore: widget.userStore,
                  );
                });
          },
        );
      },
    );
  }
}
