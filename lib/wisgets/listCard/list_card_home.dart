import 'dart:io';

import 'package:bobok/data/dummy_data.dart';
import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/wisgets/card/card_ads.dart';
import 'package:bobok/wisgets/card/card_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../provider/user_provider.dart';

class ListCard extends StatefulWidget {
  const ListCard({super.key, required this.userStore});
  final UserStore userStore;
  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final List<Review> loadReviews = dummyReviws;
  late Future<List<QueryDocumentSnapshot>> _reviewsAmigosFuture;
  late UserProvider _userProvider;

  final user = FirebaseAuth.instance.currentUser!;
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;
  var userSnapshot;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  @override
  void initState() {
    super.initState();

    _nativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            //debugPrint('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            // debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.purple,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)));
    _nativeAd?.load();
  }

  Future<void> _refreshData() async {
    try {
      getReviewsAmigos();
    } catch (error) {
      // Trate os erros, se houver, aqui.
      print("Erro ao atualizar dados: $error");
    }
  }

  Future<List<QueryDocumentSnapshot>> getReviewsAmigos() async {
    // Obtendo o usuário atualmente autenticado
    if (widget.userStore.user == null) {
      return [];
    }

    // Obtendo a lista de amigos do usuário

    List? amigos = widget.userStore.user?.following;

    // Obtendo as reviews dos amigos
    var reviewsSnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('uid', whereIn: amigos)
        .get();
    return reviewsSnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final adcode = _nativeAdIsLoaded
        ? CardAds(
            colorback: Theme.of(context).colorScheme.primary,
            ads: AdWidget(ad: _nativeAd!))
        : const SizedBox();

    return Center(
      child: Observer(
        builder: (_) {
          print(widget.userStore.user?.following);
          if (widget.userStore.user?.username == null) {
            return Text('Username: $widget.userStore.user?.username');
          } else {
            return StreamBuilder<List<QueryDocumentSnapshot>>(
              stream: getReviewsAmigos().asStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Procure Novos Avaliadores',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: getReviewsAmigos,
                  child: ListView.separated(
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) {
                      if (_nativeAdIsLoaded && index % 2 != 0 && index != 0) {
                        return adcode;
                      }
                      return const SizedBox();
                    },
                    itemBuilder: (context, index) {
                      Review review = Review.fromSnap(snapshot.data![index]);
                      return Observer(builder: (context) {
                        return CardReview(
                          colorback: review.spoiler == true
                              ? Theme.of(context).colorScheme.secondaryContainer
                              : Theme.of(context).colorScheme.primaryContainer,
                          review: review,
                          avatar: review.profileImg,
                          user: user,
                          reviewUid: review.uid,
                          userStore: widget.userStore,
                        );
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
