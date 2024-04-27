import 'dart:io';

import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/wisgets/card/card_ads_word.dart';
import 'package:bobok/wisgets/card/card_review_world.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListCardWorld extends StatefulWidget {
  const ListCardWorld({super.key, this.userStore});
  final UserStore? userStore;
  @override
  State<ListCardWorld> createState() => _ListCardWorldState();
}

class _ListCardWorldState extends State<ListCardWorld>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late Future<List<QueryDocumentSnapshot>> _reviewsAmigosFuture;

  final user = FirebaseAuth.instance.currentUser!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reviewsAmigosFuture = getReviewsAmigos();
  }

  String systemLanguagePrefix() {
    final locale = Platform.localeName;
    return locale.substring(0, 2);
  }

  String incrementLanguagePrefix(language) {
    if (language == "pt") {
      return "pu";
    } else {
      return "eo";
    }
  }

  Future<List<QueryDocumentSnapshot>> getReviewsAmigos() async {
    // Obtendo as reviews dos amigos
    if (widget.userStore!.user!.blocking!.isNotEmpty ||
        widget.userStore!.user!.blocked!.isNotEmpty) {
      var reviewsSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('language', isGreaterThanOrEqualTo: systemLanguagePrefix())
          .where('language',
              isLessThan: incrementLanguagePrefix(systemLanguagePrefix()))
          .orderBy('language')
          .orderBy("datePublish", descending: true)
          .where('uid', whereNotIn: [
        ...widget.userStore!.user!.blocking!,
        ...widget.userStore!.user!.blocked!
      ]).get();
      return reviewsSnapshot.docs;
    } else {
      var reviewsSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('language', isGreaterThanOrEqualTo: systemLanguagePrefix())
          .where('language',
              isLessThan: incrementLanguagePrefix(systemLanguagePrefix()))
          .orderBy('language')
          .orderBy("datePublish", descending: true)
          .get();
      return reviewsSnapshot.docs;
    }
  }

  Future<void> attList() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = widget.userStore!.user;
    _reviewsAmigosFuture =
        getReviewsAmigos(); // Atualiza a lista de reviews sempre que o usuário for atualizado
    return Center(
      child: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: _reviewsAmigosFuture.asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
              onRefresh: attList,
              child: ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) {
                  if (index % 2 != 0 && index != 0) {
                    return CardAdsWord(
                      colorback: Theme.of(context).colorScheme.primary,
                    );
                  }
                  return const SizedBox();
                },
                itemBuilder: (context, index) {
                  Review review = Review.fromSnap(snapshot.data![index]);
                  return CardReviewWorld(
                    colorback: review.spoiler == true
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : Theme.of(context).colorScheme.primaryContainer,
                    review: review,
                    avatar: review.profileImg,
                    user: user,
                    reviewUid: review.uid,
                    userStore: widget.userStore,
                    attList: attList,
                  );
                },
              ));
        },
      ),
    );
  }
}
