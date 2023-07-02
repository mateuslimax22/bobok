import 'dart:io';

import 'package:bobok/data/dummy_data.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/wisgets/card/card_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ListCard extends StatefulWidget {
  const ListCard({super.key, required this.onFunc});
  final Function onFunc;
  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  final List<Review> loadReviews = dummyReviws;

  final user = FirebaseAuth.instance.currentUser!;
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAd();
  }

  void loadAd() {
    _nativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
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

  @override
  Widget build(BuildContext context) {
    final adcode = Container(
      constraints: const BoxConstraints(
        minWidth: 320, // minimum recommended width
        minHeight: 320, // minimum recommended height
        maxWidth: 400,
        maxHeight: 400,
      ),
      child: AdWidget(ad: _nativeAd!),
    );
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .orderBy("datePublish", descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.separated(
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (context, index) {
            if (_nativeAdIsLoaded && index % 2 != 0 && index != 0)
              return adcode;
            return const SizedBox();
          },
          itemBuilder: (context, index) {
            Review review = Review.fromSnap(snapshot.data!.docs[index]);
            return CardReview(
              colorback: review.spoiler == true
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Theme.of(context).colorScheme.primaryContainer,
              review: review,
              avatar: review.profileImg,
              user: user,
              reviewUid: review.uid,
              onFunc: widget.onFunc,
            );
          },
        );
      },
    );
  }
}
