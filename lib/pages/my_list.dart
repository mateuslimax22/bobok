import 'dart:io';
import 'package:bobok/utils/constants.dart';
import 'package:bobok/wisgets/card/card_myfav.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:bobok/mobx/user_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyList extends StatefulWidget {
  const MyList({super.key, this.userStore});
  final UserStore? userStore;

  @override
  // ignore: library_private_types_in_public_api
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  late String selectedTab;
  late AutoScrollController _scrollController;

  BannerAd? _nativeAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-6374572075612830/2049242287'
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedTab = getCategoryName(0); // Definir a categoria inicial aqui
    _scrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );
  }

  void attList() {
    setState(() {});
  }

  String getCategoryName(int index) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.book;
      case 1:
        return AppLocalizations.of(context)!.manga;
      case 2:
        return AppLocalizations.of(context)!.comic;
      case 3:
        return AppLocalizations.of(context)!.movie;
      case 4:
        return AppLocalizations.of(context)!.serie;
      case 5:
        return AppLocalizations.of(context)!.anime;
      default:
        return "";
    }
  }

  List getFilteredMyFav() {
    if (widget.userStore?.user?.myfav == null) {
      return [];
    }
    // Mapa de categorias em diferentes idiomas
    final categoryTranslations = {
      AppLocalizations.of(context)!.book: ['Livro', 'Book'],
      AppLocalizations.of(context)!.manga: ['Mangá', 'Manga'],
      AppLocalizations.of(context)!.comic: ['HQ', 'Comic'],
      AppLocalizations.of(context)!.movie: ['Filme', 'Movie'],
      AppLocalizations.of(context)!.serie: ['Série', 'Series'],
      AppLocalizations.of(context)!.anime: ['Anime', 'Anime']
    };

    // Verifica se a categoria atual corresponde a algum valor no mapa
    return widget.userStore!.user!.myfav!.where((item) {
      final currentCategory = item['category'];
      // Verifica se a chave existe no mapa e, em seguida, verifica se a categoria atual corresponde a algum valor da lista
      return categoryTranslations[selectedTab]?.contains(currentCategory) ??
          false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight,
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.background),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.myList,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              children: List.generate(
                6,
                (index) => buildTab(getCategoryName(index), index: index),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3.0,
                  ),
                ),
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.onError,
              ),
              child: getFilteredMyFav().isEmpty
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: Text(
                              AppLocalizations.of(context)!.emptyList,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      itemCount: getFilteredMyFav().length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: (2.8 / 4),
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                      ),
                      itemBuilder: (ctx, i) => CardMyFav(
                        fav: getFilteredMyFav()[i],
                        myfav: widget.userStore?.user?.myfav,
                        userStore: widget.userStore,
                        attList: attList,
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
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                      height: 45,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
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
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  Widget buildTab(String tabName, {required int index}) {
    bool isSelected = selectedTab == tabName;

    return AutoScrollTag(
      key: ValueKey(index),
      controller: _scrollController,
      index: index,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = getCategoryName(index);
          });
          _scrollController.scrollToIndex(index,
              preferPosition: AutoScrollPosition.begin);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: Radius.circular(isSelected ? 0 : 12),
              bottomRight: Radius.circular(isSelected ? 0 : 12),
            ),
          ),
          child: Text(
            tabName,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.primary,
              letterSpacing: 0.5,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
