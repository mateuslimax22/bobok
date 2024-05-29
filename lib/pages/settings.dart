import 'dart:io';
import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/provider/google_sign_in.dart';
import 'package:bobok/provider/user_provider.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key, this.userStore});
  final UserStore? userStore;

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  void logout() async {
    await widget.userStore?.clearUserFromCache();
    // ignore: use_build_context_synchronously
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.clearUser();
    final provider =
        // ignore: use_build_context_synchronously
        Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.logout();
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.transparent, // torna a área transparente clicável
        child: Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: const Offset(0.0, 0.0),
            ).animate(CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeInOut,
            )),
            child: GestureDetector(
              onTap: () {}, // impedir que o clique seja propagado para fora
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                  child: Column(
                    children: [
                      ListTile(
                          leading: Icon(
                            Icons.palette,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          title: Text(AppLocalizations.of(context)!.edtPro,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.EDITPROFILE,
                              arguments: {
                                'userStore': widget.userStore,
                              },
                            );
                          }),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        title: Text('Logout',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            )),
                        onTap: () {
                          logout();
                          Navigator.of(context).pop();
                        },
                      ),
                      const Spacer(),
                      SizedBox(
                        child: _nativeAd == null
                            // Nothing to render yet.
                            ? const SizedBox()
                            // The actual ad.
                            : Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  height: 45,
                                  width: 320,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
