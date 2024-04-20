// ignore_for_file: dead_code
import 'package:bobok/wisgets/btn/elevated.dart';
import 'dart:io';
import 'package:bobok/provider/auth_email.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  File? _avatar;
  bool spoiler = false;
  bool msgError = false;
  bool notValid = false;
  bool isLoading = false;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  String levelPassword = "Fraca";
  bool is6Digits = false;
  bool isUppercase = false;
  bool isNumber = false;
  bool isLoadingRegister = false;
  bool isSpecialCharacters = false;
  RewardedAd? _rewardedAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-6374572075612830/8060249344';

  @override
  void initState() {
    super.initState();
    showRewardedAd();
  }

  void showRewardedAd() {
    RewardedAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});

          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('RewardedAd failed to load: $error');
        }));
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    void uploadImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
      );

      if (image != null) {
        setState(() {
          _avatar = File(image.path);
        });
      }
    }

    // ignore: no_leading_underscores_for_local_identifiers
    Future<void> _submitForm() async {
      _formKey.currentState?.save();
      final isValid = _formKey.currentState?.validate() ?? false;

      if (!isValid) {
        notValid = true;
        return;
      }

      setState(() {
        isLoading = true;
      });

      await AuthEmail(context).updateProfile(
          arguments['userStore'].user.uid,
          _formData["user"].toString(),
          arguments['userStore'].user.avatar,
          _avatar,
          arguments['userStore']);
      setState(() {
        isLoading = false;
      });
      _rewardedAd?.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        // ignore: avoid_print
        print('Reward amount: ${rewardItem.amount}');
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.edtPro,
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
        backgroundColor: Theme.of(context).colorScheme.onError,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
              ),
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.onError),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(4), // Border width
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.2),
                                  spreadRadius: 0.3,
                                  blurRadius: 1,
                                  offset: const Offset(0, 2),
                                ),
                              ]),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.warning_amber_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Flexible(
                                child:
                                    Text(AppLocalizations.of(context)!.upField,
                                        style: TextStyle(
                                          letterSpacing: 0.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 110,
                          width: 110,
                          child: Stack(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.all(4), // Border width
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(
                                        48), // Image radius
                                    child: _avatar == null
                                        ? IconButton(
                                            padding: const EdgeInsets.all(0),
                                            icon: Icon(
                                              Icons.person,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              size: 80,
                                            ),
                                            onPressed: () {
                                              uploadImage();
                                            },
                                          )
                                        : Image.file(
                                            _avatar!,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: RawMaterialButton(
                                      onPressed: () {},
                                      elevation: 2.0,
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        icon: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        onPressed: () {
                                          uploadImage();
                                        },
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Text(AppLocalizations.of(context)!.attPhoto,
                          style: TextStyle(
                            letterSpacing: 0.5,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: PhysicalModel(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).colorScheme.background,
                            elevation: 2.0,
                            shadowColor:
                                Theme.of(context).colorScheme.onPrimary,
                            child: TextFormField(
                              maxLength: 15,
                              style: TextStyle(
                                letterSpacing: 0.5,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                labelText:
                                    AppLocalizations.of(context)!.attName,
                                labelStyle: TextStyle(
                                  letterSpacing: 0.5,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 0),
                              ),
                              textInputAction: TextInputAction.next,
                              onSaved: (user) {
                                _formData['user'] = user ?? '';
                              },
                              validator: (user) {
                                final title = user ?? '';

                                if (title.trim().isEmpty && _avatar == null) {
                                  return AppLocalizations.of(context)!.notAtt;
                                }

                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButtonTh(
                          label: AppLocalizations.of(context)!.update,
                          target: () async {
                            _submitForm();
                          },
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          width: 260,
                          height: 45,
                          isLoading: isLoading,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
