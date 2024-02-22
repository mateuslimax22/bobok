import 'dart:io';

import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/wisgets/card/card_ads_word.dart';
import 'package:bobok/wisgets/card/card_review_world.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

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
            // debugPrint('$NativeAd loaded.');
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
            templateType: TemplateType.small,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reviewsAmigosFuture = getReviewsAmigos();
  }

  Future<List<QueryDocumentSnapshot>> getReviewsAmigos() async {
    // Obtendo as reviews dos amigos
    var reviewsSnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .orderBy('uid', descending: true)
        .get();
    return reviewsSnapshot.docs;
  }

  Future<void> attList() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final adcode = _nativeAdIsLoaded
        ? CardAdsWord(
            colorback: Theme.of(context).colorScheme.primary,
            ads: AdWidget(ad: _nativeAd!))
        : const SizedBox();

    return StreamBuilder<List<QueryDocumentSnapshot>>(
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
                if (_nativeAdIsLoaded && index % 2 != 0 && index != 0) {
                  return adcode;
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
                );
              },
            ));
      },
    );
  }
}
