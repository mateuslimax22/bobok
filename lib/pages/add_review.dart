import 'package:bobok/models/review.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';

class AddReview extends StatefulWidget {
  const AddReview({super.key});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  // Initial Selected Value
  String dropdownvalue = 'Livro';
  String img = 'https://color-hex.org/colors/5d3fd3.png';
  final user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool spoiler = false;
  bool msgError = false;
  bool notValid = false;
  bool isLoading = false;
  String titleFolder = '';

  List<String> genresSelect = [];
  FocusNode myFocusNodeTitle = FocusNode();
  FocusNode myFocusNodeReview = FocusNode();

  // List of items in our dropdown menu
  var items = [
    'Livro',
    'Mangá',
    'HQ',
    'Filme',
    'Série',
    'Anime',
  ];

  var genres = [
    'Ação/aventura',
    'Ficção científica',
    'Thriller/Suspense',
    'Romance',
    'Infantil',
    'Autoajuda',
    'Guias & Como fazer',
    'Tecnologia e Ciência',
    'Ficção Policial',
    'LGBTQ+',
  ];
  @override
  void initState() {
    super.initState();
    myFocusNodeTitle.addListener(() {
      setState(() {});
    });

    myFocusNodeReview.addListener(() {
      setState(() {});
    });
  }

  Future<void> _submitForm() async {
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
      title: _formData["title"].toString(),
      review: _formData["review"].toString(),
      imageUrl: img.toString(),
      likes: "0",
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
          newReview.category,
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
    final webScraper = WebScraper('https://www.google.com.br/');
    if (await webScraper.loadWebPage(
        'search?q=$titleFolder+capa&tbm=isch&ved=2ahUKEwiA5-mJ5Oj-AhUOObkGHVTDA40Q2-cCegQIABAA&oq=harry+po&gs_lcp=CgNpbWcQARgBMgQIIxAnMggIABCABBCxAzIICAAQgAQQsQMyCAgAEIAEELEDMggIABCABBCxAzIHCAAQigUQQzIHCAAQigUQQzIICAAQgAQQsQMyCAgAEIAEELEDMggIABCABBCxAzoKCAAQigUQsQMQQ1AAWLYCYKYQaABwAHgAgAGEAYgBhgOSAQMwLjOYAQCgAQGqAQtnd3Mtd2l6LWltZ8ABAQ&sclient=img&ei=nIVaZICpC47y5OUP1IaP6Ag&authuser=0&bih=912&biw=1447&hl=pt-BR')) {
      var tiktokProfilePictureURL = webScraper.getElement('img', ['src']);
      var result = tiktokProfilePictureURL.map((item) {
        return item;
      }).toList();
      setState(() {
        img = (result[1]["attributes"]["src"]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _formData['category'] = dropdownvalue;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nova Resenha",
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
                  onPressed: _submitForm,
                  icon: const Icon(Icons.done),
                  iconSize: 30,
                )
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "Selecione a categoria:",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: PhysicalModel(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.background,
                                elevation: 2.0,
                                shadowColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: DropdownButton(
                                    // Initial Value
                                    value: dropdownvalue,
                                    isExpanded: true,
                                    underline: Container(),

                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),

                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),

                                    // Array list of items
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
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
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: PhysicalModel(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.background,
                                elevation: 2.0,
                                shadowColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                child: TextFormField(
                                  focusNode: myFocusNodeTitle,
                                  decoration: InputDecoration(
                                    labelText: "Título",
                                    labelStyle: TextStyle(
                                        color: myFocusNodeTitle.hasFocus
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
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
                                    contentPadding: const EdgeInsets.symmetric(
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
                                      return 'Título obrigatório.';
                                    }

                                    return null;
                                  },
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: SwitchListTile(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              activeColor:
                                  Theme.of(context).colorScheme.primary,
                              title: const Text('Contém Spoiler?'),
                              value: spoiler,
                              onChanged: (bool value) {
                                setState(() {
                                  spoiler = value;
                                });
                              },
                              secondary: const Icon(
                                Icons.warning_rounded,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: msgError == false
                                ? Text(
                                    "Selecione o gênero :",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  )
                                : const Text(
                                    "Selecione o gênero : *",
                                    style: TextStyle(
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withOpacity(0.35),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox.fromSize(
                                  child: GestureDetector(
                                    child: Image?.network(img,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.27,
                                        height: 150,
                                        fit: BoxFit.cover),
                                    onTap: () {},
                                  ),
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
                                    : Theme.of(context).colorScheme.background,
                              ),
                              onPressed: () {
                                _getImage();
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
                                    color: genresSelect.contains(genres[index])
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
                          maxLines: 2000,
                          decoration: InputDecoration(
                            labelText: "Resenha",
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(
                                color: myFocusNodeReview.hasFocus
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onPrimary),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                            contentPadding:
                                const EdgeInsets.fromLTRB(8, 10, 0, 0),
                          ),
                          keyboardType: TextInputType.multiline,
                          onSaved: (review) {
                            _formData['review'] = review ?? '';
                          },
                          validator: (_review) {
                            final review = _review ?? '';

                            if (review.trim().isEmpty) {
                              return 'Cadê a resenha ????';
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
    );
  }
}
