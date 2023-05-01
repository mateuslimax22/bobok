import 'dart:math';

import 'package:bobok/models/review.dart';
import 'package:flutter/material.dart';

class AddReview extends StatefulWidget {
  const AddReview({super.key});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  // Initial Selected Value
  String dropdownvalue = 'Livro';
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  // List of items in our dropdown menu
  var items = [
    'Livro',
    'Mangá',
    'HQ',
    'Filme',
    'Série',
    'Anime',
  ];

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    final newReview = Review(
        id: Random().nextDouble().toString(),
        username: "username",
        title: _formData["title"].toString(),
        review: _formData["review"].toString(),
        imageUrl:
            "https://m.media-amazon.com/images/I/41897yAI4LL._SY344_BO1,204,203,200_QL70_ML2_.jpg",
        likes: "0",
        spoiler: false,
        category: _formData["category"].toString());

    print(newReview.review);
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
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.done),
            iconSize: 30,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
            key: _formKey,
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
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(color: Colors.black38, width: 1),
                                //blur radius of shadow
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: DropdownButton(
                                  // Initial Value
                                  value: dropdownvalue,
                                  isExpanded: true,
                                  underline: Container(),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),

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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Título",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: TextFormField(
                    maxLines: 2000,
                    decoration: const InputDecoration(
                      labelText: "Resenha",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
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
              ],
            )),
      ),
    );
  }
}
