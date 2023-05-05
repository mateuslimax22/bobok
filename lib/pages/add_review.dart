import 'dart:convert';
import 'dart:math';

import 'package:bobok/models/review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddReview extends StatefulWidget {
  const AddReview({super.key});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  // Initial Selected Value
  String dropdownvalue = 'Livro';
  String img =
      'https://m.media-amazon.com/images/I/51TMmMNtZiL._SX331_BO1,204,203,200_.jpg';
  final user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool msgError = false;
  bool notValid = false;
  bool isLoading = false;

  List<String> genresSelect = [];
  FocusNode myFocusNodeTitle = new FocusNode();
  FocusNode myFocusNodeReview = new FocusNode();

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
      id: Random().nextDouble().toString(),
      username: user.displayName!,
      title: _formData["title"].toString(),
      review: _formData["review"].toString(),
      imageUrl:
          "https://m.media-amazon.com/images/I/41897yAI4LL._SY344_BO1,204,203,200_QL70_ML2_.jpg",
      likes: "0",
      spoiler: false,
      category: _formData["category"].toString(),
      genres: genresSelect,
    );

    setState(() {
      isLoading = true;
    });

    try {
      const baseUrl = 'https://bobok-cc168-default-rtdb.firebaseio.co';
      var resp = await post(
        Uri.parse('$baseUrl/Reviews.json'),
        body: jsonEncode({
          'id': Random().nextDouble().toString(),
          'username': newReview.username,
          'title': newReview.title,
          'review': newReview.review,
          'imageUrl': newReview.imageUrl,
          'likes': newReview.likes,
          'spoiler': newReview.spoiler,
          'category': newReview.category,
          'genres': newReview.genres,
        }),
      );
      if (resp.statusCode != 200) {
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
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getImage() async {
    try {
      const baseUrl =
          'https://serpapi.com/search.json?q=Apple&engine=google_images&ijn=0';
      var resp = await get(
        Uri.parse(baseUrl),
      );
      if (resp.statusCode != 200) {
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
        print(jsonDecode(resp.body)['images_results'][0]['thumbnail']);
        setState(() {
          img = jsonDecode(resp.body)['images_results'][0]['thumbnail'];
        });
      }
    } catch (e) {
      print(e);
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
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            width: MediaQuery.of(context).size.width * 0.5,
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
                            width: MediaQuery.of(context).size.width * 0.5,
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
                                        .primary
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
                                    child: Image.network(img,
                                        width: 100,
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
