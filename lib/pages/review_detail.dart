import 'dart:io';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/utils/constants.dart';
import 'package:bobok/wisgets/animated/comments_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ReviewDetail extends StatefulWidget {
  const ReviewDetail({
    super.key,
  });

  @override
  State<ReviewDetail> createState() => _ReviewDetailState();
}

class _ReviewDetailState extends State<ReviewDetail> {
  bool isLike = false;
  bool isSave = false;
  int countLikes = 0;
  BannerAd? _nativeAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-6374572075612830/5574188780'
      : 'ca-app-pub-6374572075612830/8060249344';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
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

  get arguments =>
      (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{})
          as Map;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      countLikes = arguments['reviewAll'].likes.length;
    });
    if (arguments['reviewAll'].likes.contains(arguments['userUid'])) {
      setState(() {
        isLike = true;
      });
    }
    if (arguments['myFav']
        .any((map) => map['imageUrl'] == arguments['reviewAll'].imageUrl)) {
      setState(() {
        isSave = true;
      });
    }
  }

  void removeFav(List<dynamic>? myfav, Map<String, dynamic> fav) async {
    myfav?.removeWhere((item) => item['imageUrl'] == fav['imageUrl']);

    await FirestoreMethods().removeFav(arguments['userUid'], fav);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          // ignore: use_build_context_synchronously
          backgroundColor: Theme.of(context).colorScheme.onError,
          content: Text(
            // ignore: use_build_context_synchronously
            AppLocalizations.of(context)!.snakRmv,
            style: TextStyle(
                // ignore: use_build_context_synchronously
                color: Theme.of(context).colorScheme.primary,
                fontSize: 15,
                letterSpacing: 1.5),
          )),
    );
  }

  void setFav(Map<String, dynamic> fav) {
    FirestoreMethods().addFav(arguments['userUid'], [fav]);
    arguments['myFav'].add(fav);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          // ignore: use_build_context_synchronously
          backgroundColor: Theme.of(context).colorScheme.onError,
          content: Text(
            // ignore: use_build_context_synchronously
            AppLocalizations.of(context)!.snakAdd,
            style: TextStyle(
                // ignore: use_build_context_synchronously
                color: Theme.of(context).colorScheme.primary,
                fontSize: 15,
                letterSpacing: 1.5),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          arguments['title'],
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 25,
              letterSpacing: 1.5),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.primary,
        titleSpacing: 5,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: deviceHeight,
              width: deviceWidth,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.7),
              ),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Expanded(
                  child: Container(
                    width: deviceWidth,
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.85),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 35,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    child: arguments['profileImg'] == null
                                        ? IconButton(
                                            padding: const EdgeInsets.all(0),
                                            icon: Icon(
                                              Icons.person,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              size: 40,
                                            ),
                                            onPressed: () {},
                                          )
                                        : Image.network(arguments['profileImg'],
                                            fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  arguments['userName'],
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 20,
                                      letterSpacing: 1.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .review
                                  .toUpperCase(),
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 18,
                                  letterSpacing: 1.5),
                            ),
                          ),
                        ),
                        arguments['isComment'] == false
                            ? Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 0, 3),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: SingleChildScrollView(
                                            child: Text(
                                              arguments['review'],
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      child: _nativeAd == null
                                          // Nothing to render yet.
                                          ? const SizedBox()
                                          // The actual ad.
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, bottom: 5),
                                              child: Container(
                                                height: 45,
                                                width: 350,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                          .withOpacity(0.35),
                                                      spreadRadius: 1,
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: AdWidget(ad: _nativeAd!),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: deviceHeight * 0.1,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 0, 3),
                                            child: Text(
                                              arguments['review'],
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(50, 30),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 3),
                                        child: Text(
                                          AppLocalizations.of(context)!.seeMore,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontSize: 14,
                                              letterSpacing: 1.5),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          arguments['isComment'] = false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                        arguments['isComment'] == false
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 3.0,
                                      ),
                                    ),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5)),
                                    color:
                                        Theme.of(context).colorScheme.onError),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: IconButton(
                                          icon: Icon(Icons.star_border_rounded,
                                              size: 25,
                                              color: isLike
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                          tooltip: 'Show Snackbar',
                                          onPressed: () async {
                                            setState(() {
                                              isLike = !isLike;
                                            });
                                            setState(() {
                                              isLike
                                                  ? countLikes = ++countLikes
                                                  : countLikes = --countLikes;
                                            });
                                            await FirestoreMethods().likePost(
                                                arguments['reviewAll'].postId,
                                                arguments['userUid'],
                                                isLike);
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: 30,
                                        width: 40,
                                        child: Text(
                                          countLikes.toString(),
                                          style: TextStyle(
                                              color: isLike
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary),
                                        )),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: SizedBox(
                                        height: 40,
                                        width: 30,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.messenger_outline,
                                            size: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                          tooltip: 'Show Snackbar',
                                          onPressed: () {
                                            setState(() {
                                              arguments['isComment'] = true;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: SizedBox(
                                        height: 40,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.bookmark_add_outlined,
                                            size: 20,
                                            color: isSave
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                          ),
                                          tooltip: 'Show Snackbar',
                                          onPressed: () {
                                            setState(() {
                                              isSave = !isSave;
                                            });
                                            setState(() {
                                              isSave
                                                  ? setFav({
                                                      "title":
                                                          arguments['reviewAll']
                                                              .title,
                                                      "category":
                                                          arguments['reviewAll']
                                                              .category,
                                                      "imageUrl":
                                                          arguments['reviewAll']
                                                              .imageUrl
                                                    })
                                                  : removeFav(
                                                      arguments['myFav'], {
                                                      "title":
                                                          arguments['reviewAll']
                                                              .title,
                                                      "category":
                                                          arguments['reviewAll']
                                                              .category,
                                                      "imageUrl":
                                                          arguments['reviewAll']
                                                              .imageUrl
                                                    });
                                            });
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Expanded(
                                child: CommentsCard(
                                    userStore: arguments['userStore'],
                                    avatar: arguments['currentUserPhoto'],
                                    userUid: arguments['userUid'],
                                    postId: arguments['postId'],
                                    userName: arguments['currentUserName']),
                              )
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
