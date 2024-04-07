import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';

class AddReview extends StatefulWidget {
  const AddReview({super.key});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  // Initial Selected Value
  String img = '';
  final user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  late UserStore userStore;

  bool spoiler = false;
  bool msgError = false;
  bool notValid = false;
  bool isLoading = false;
  bool mature = false;
  String titleFolder = '';
  String dropdownvalue = "";

  List<String> genresSelect = [];
  FocusNode myFocusNodeTitle = FocusNode();
  FocusNode myFocusNodeReview = FocusNode();

  // List of items in our dropdown menu

  @override
  void initState() {
    super.initState();
    myFocusNodeTitle.addListener(() {
      setState(() {});
    });
    myFocusNodeTitle.addListener(_onTitleFocusChange);
    myFocusNodeReview.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    myFocusNodeTitle.removeListener(_onTitleFocusChange);
    super.dispose();
  }

  void _onTitleFocusChange() {
    if (!myFocusNodeTitle.hasFocus) {
      _getImage();
    }
  }

  String getSystemLocaleString() {
    final locale = Platform.localeName;
    if (locale.contains('_')) {
      final parts = locale.split('_');
      return '${parts[0]}_${parts[1].toUpperCase()}';
    }
    return locale;
  }

  Future submitForm(String profileImg) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      notValid = true;
      return;
    }

    if (genresSelect.isEmpty) {
      setState(() {
        msgError = true;
      });
      return;
    }

    _formKey.currentState?.save();

    final newReview = Review(
      username: user.displayName!,
      searchname: user.displayName!.toLowerCase(),
      title: _formData["title"].toString(),
      review: _formData["review"].toString(),
      imageUrl: img.toString(),
      likes: "0",
      language: getSystemLocaleString(),
      spoiler: spoiler,
      category: _formData["category"].toString(),
      genres: genresSelect,
    );

    setState(() {
      isLoading = true;
    });

    try {
      String res = await FirestoreMethods().uploadReview(
          newReview.imageUrl,
          newReview.username,
          newReview.title,
          newReview.review,
          newReview.spoiler,
          profileImg,
          newReview.category,
          newReview.language,
          newReview.genres);

      if (res != "sucess") {
        // ignore: use_build_context_synchronously
        showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Ocorreu um erro!"),
                  content: const Text("Não foi possivel salvar sua resenha ;("),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("OK"))
                  ],
                ));
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Ocorreu um erro!"),
                content: const Text("Não foi possivel salvar sua resenha ;("),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("OK"))
                ],
              ));
    }
  }

  Future<void> _getImage() async {
    if (titleFolder != '') {
      final webScraper = WebScraper('https://www.google.com.br/');
      if (await webScraper.loadWebPage(
          'search?q=$titleFolder+capa&tbm=isch&ved=2ahUKEwiA5-mJ5Oj-AhUOObkGHVTDA40Q2-cCegQIABAA&oq=harry+po&gs_lcp=CgNpbWcQARgBMgQIIxAnMggIABCABBCxAzIICAAQgAQQsQMyCAgAEIAEELEDMggIABCABBCxAzIHCAAQigUQQzIHCAAQigUQQzIICAAQgAQQsQMyCAgAEIAEELEDMggIABCABBCxAzoKCAAQigUQsQMQQ1AAWLYCYKYQaABwAHgAgAGEAYgBhgOSAQMwLjOYAQCgAQGqAQtnd3Mtd2l6LWltZ8ABAQ&sclient=img&ei=nIVaZICpC47y5OUP1IaP6Ag&authuser=0&bih=912&biw=1447&hl=pt-BR')) {
        var tiktokProfilePictureURL = webScraper.getElement('img', ['src']);

        var result = tiktokProfilePictureURL.map((item) {
          return item;
        }).toList();
        if (result[1]["attributes"]["src"].contains("visibility_off")) {
          setState(() {
            mature = true;
          });
        } else {
          setState(() {
            img = (result[1]["attributes"]["src"]);
            mature = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    var items = [
      AppLocalizations.of(context)!.book,
      AppLocalizations.of(context)!.manga,
      AppLocalizations.of(context)!.comic,
      AppLocalizations.of(context)!.movie,
      AppLocalizations.of(context)!.serie,
      AppLocalizations.of(context)!.anime,
    ];

    var genres = [
      AppLocalizations.of(context)!.actionAdventure,
      AppLocalizations.of(context)!.scienceFiction,
      AppLocalizations.of(context)!.thrillerSuspense,
      AppLocalizations.of(context)!.romance,
      AppLocalizations.of(context)!.children,
      AppLocalizations.of(context)!.selfHelp,
      AppLocalizations.of(context)!.guidesHowTo,
      AppLocalizations.of(context)!.technologyScience,
      AppLocalizations.of(context)!.detectiveFiction,
      AppLocalizations.of(context)!.lgbtqPlus,
    ];
    _formData['category'] = dropdownvalue;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.newRe,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 25,
              letterSpacing: 1.5),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.primary,
        titleSpacing: 5,
        actions: [
          isLoading
              ? const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(),
                )
              : IconButton(
                  onPressed: () {
                    submitForm(arguments['userStore'].user.avatar);
                  },
                  icon: const Icon(Icons.done),
                  iconSize: 30,
                )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.onError,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 3.0,
              ),
            ),
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.onError),
        child: SingleChildScrollView(
          reverse: false,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
                key: _formKey,
                autovalidateMode: notValid == true
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                AppLocalizations.of(context)!.selCat,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: PhysicalModel(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  elevation: 2.0,
                                  shadowColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: DropdownButton(
                                      // Initial Value
                                      value: dropdownvalue == ""
                                          ? AppLocalizations.of(context)!.book
                                          : dropdownvalue,
                                      isExpanded: true,
                                      underline: Container(),

                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),

                                      // Down Arrow Icon
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),

                                      // Array list of items
                                      items: items.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(
                                            items,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontSize: 15,
                                                letterSpacing: 1.5),
                                          ),
                                        );
                                      }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvalue = newValue!;
                                        });

                                        _formData['category'] = dropdownvalue;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: PhysicalModel(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  elevation: 2.0,
                                  shadowColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  child: TextFormField(
                                    focusNode: myFocusNodeTitle,
                                    maxLength: 20,
                                    style: TextStyle(
                                      letterSpacing: 0.5,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                    decoration: InputDecoration(
                                      labelText:
                                          AppLocalizations.of(context)!.title,
                                      labelStyle: TextStyle(
                                          color: myFocusNodeTitle.hasFocus
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                      border: InputBorder.none,
                                      counterText: '',
                                      errorStyle: const TextStyle(
                                        height:
                                            1, // Definir a altura do texto de erro
                                      ),
                                      errorMaxLines: 3,
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.red),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5.0)),
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 0),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    onChanged: (value) {
                                      titleFolder = value;
                                    },
                                    onSaved: (title) {
                                      _formData['title'] = title ?? '';
                                    },
                                    validator: (_title) {
                                      final title = _title ?? '';

                                      if (title.trim().isEmpty) {
                                        return AppLocalizations.of(context)!
                                            .titReq;
                                      }

                                      if (title.trim().length <= 3) {
                                        return AppLocalizations.of(context)!
                                            .titleng;
                                      }

                                      if (mature == true) {
                                        return AppLocalizations.of(context)!
                                            .titMature;
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: SwitchListTile(
                                inactiveThumbColor:
                                    Theme.of(context).colorScheme.primary,
                                inactiveTrackColor:
                                    Theme.of(context).colorScheme.secondary,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                title: Text(
                                  AppLocalizations.of(context)!.ySpoiler,
                                  style: TextStyle(
                                    letterSpacing: 0.5,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                value: spoiler,
                                onChanged: (bool value) {
                                  setState(() {
                                    spoiler = value;
                                  });
                                },
                                secondary: const Icon(
                                  Icons.warning_rounded,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: msgError == false
                                  ? Text(
                                      AppLocalizations.of(context)!.selGen,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    )
                                  : Text(
                                      AppLocalizations.of(context)!.selGenError,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
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
                                  ],
                                ),
                                child: img != ''
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SizedBox.fromSize(
                                          child: GestureDetector(
                                            child: Image?.network(img,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.27,
                                                height: 150,
                                                fit: BoxFit.cover),
                                            onTap: () {},
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.27,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: genres.length,
                        itemBuilder: (context, index) {
                          final button = genres[index];
                          return SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  backgroundColor: genresSelect
                                          .contains(genres[index])
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .background,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (genresSelect.contains(genres[index])) {
                                      genresSelect.remove(genres[index]);
                                    } else {
                                      genresSelect.add(genres[index]);
                                      msgError = false;
                                    }
                                  });
                                },
                                child: Text(
                                  button,
                                  style: TextStyle(
                                      color:
                                          genresSelect.contains(genres[index])
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .background
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.5),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 250),
                        child: PhysicalModel(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.background,
                          elevation: 2.0,
                          shadowColor: Theme.of(context).colorScheme.onPrimary,
                          child: TextFormField(
                            focusNode: myFocusNodeReview,
                            style: TextStyle(
                              letterSpacing: 0.5,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            maxLines: 2000,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.writeRw,
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(
                                  color: myFocusNodeReview.hasFocus
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(8, 15, 0, 0),
                            ),
                            keyboardType: TextInputType.multiline,
                            onSaved: (review) {
                              _formData['review'] = review ?? '';
                            },
                            validator: (_review) {
                              final review = _review ?? '';

                              if (review.trim().isEmpty) {
                                return AppLocalizations.of(context)!.wheRw;
                              }

                              if (review.trim().length <= 5) {
                                return AppLocalizations.of(context)!.rwLen;
                              }

                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
