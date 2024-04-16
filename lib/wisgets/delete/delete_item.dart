import 'dart:io';
import 'package:bobok/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class DeleteConfirmationModal extends StatefulWidget {
  final String item;
  final VoidCallback onDelete;
  final bool isVisible;

  const DeleteConfirmationModal({
    super.key,
    required this.item,
    required this.onDelete,
    required this.isVisible,
  });

  @override
  State<DeleteConfirmationModal> createState() =>
      _DeleteConfirmationModalState();
}

class _DeleteConfirmationModalState extends State<DeleteConfirmationModal> {
  BannerAd? _nativeAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
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
  Widget build(BuildContext context) {
    if (widget.isVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SizedBox(
                height: deviceHeight * 0.16,
                width: deviceWidth,
                child: Column(
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.deleteItem}${widget.item}?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 15,
                        letterSpacing: 1.4,
                      ),
                    ),
                    SizedBox(
                      child: _nativeAd == null
                          // Nothing to render yet.
                          ? const SizedBox()
                          // The actual ad.
                          : Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                height: 50,
                                width: 350,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
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
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 15,
                          letterSpacing: 1.5)),
                ),
                TextButton(
                  onPressed: () {
                    widget.onDelete();
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.confirm,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      });
    }

    return Container(); // Return an empty container, as we don't want to render anything here.
  }
}
