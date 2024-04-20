import 'dart:io';
import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../card/card_comment.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CommentsCard extends StatefulWidget {
  const CommentsCard(
      {super.key,
      required this.avatar,
      required this.postId,
      required this.userUid,
      required this.userName,
      required this.userStore});
  final String? avatar;
  final String postId;
  final String userName;
  final String userUid;
  final UserStore? userStore;

  @override
  State<CommentsCard> createState() => _CommentsCard();
}

class _CommentsCard extends State<CommentsCard> {
  TextEditingController _textEditingController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    super.dispose();
    _textEditingController
        .dispose(); // Lembre-se de liberar o controller quando não for mais necessário.
    _nativeAd?.dispose();
  }

  BannerAd? _nativeAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-6374572075612830/8060249344';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    final bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: _adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _nativeAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 3.0,
            ),
          ),
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.onError),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('reviews')
                        .doc(widget.postId)
                        .collection('comments')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Text(
                          AppLocalizations.of(context)!.noComm,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return CardComment(
                            userStore: widget.userStore,
                            snap: snapshot.data!.docs[index],
                            userId: widget.userUid,
                            postId: widget.postId,
                          );
                        },
                      );
                    })),
            SizedBox(
              child: _nativeAd == null
                  // Nothing to render yet.
                  ? const SizedBox()
                  // The actual ad.
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 45,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.35),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: AdWidget(ad: _nativeAd!),
                      ),
                    ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 45,
                    height: 35,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child: widget.avatar == null
                            ? IconButton(
                                padding: const EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.person,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 40,
                                ),
                                onPressed: () {},
                              )
                            : Image.network(widget.avatar!, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextField(
                        controller: _textEditingController,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                            letterSpacing: 1.5),
                        decoration: InputDecoration(
                            hintText: "Adicione um comentário",
                            fillColor: Theme.of(context).colorScheme.primary,
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () async {
                      await FirestoreMethods().postComment(
                          widget.postId,
                          _textEditingController.text,
                          user.uid,
                          widget.userName,
                          widget.avatar);
                      setState(() {
                        _textEditingController.text = '';
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
