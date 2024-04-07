import 'package:bobok/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _Search();
}

class _Search extends State<Search> {
  final TextEditingController textEditingController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    textEditingController
        .dispose(); // Lembre-se de liberar o controller quando não for mais necessário.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    String searchTextUpperBound = textEditingController.text.isNotEmpty
        ? textEditingController.text
                .substring(0, textEditingController.text.length - 1) +
            String.fromCharCode(textEditingController.text
                    .codeUnitAt(textEditingController.text.length - 1) +
                1)
        : "";
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.primary,
          titleSpacing: 5,
          title: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.searchUser),
            onChanged: (String value) {
              setState(() {
                isShowUsers = true;
              });
              if (value == '') {
                setState(() {
                  isShowUsers = false;
                });
              }
            },
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      'searchname',
                      isGreaterThanOrEqualTo: textEditingController.text,
                    )
                    .where('searchname', isLessThan: searchTextUpperBound)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profile(
                                      uid: snapshot.data!.docs[index]['uid'],
                                      userStore: arguments['userStore'],
                                      currentUid: false),
                                ),
                              )
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                          48), // Image radius
                                      child: snapshot.data!.docs[index]
                                                  ['photoUrl'] ==
                                              null
                                          ? IconButton(
                                              padding: const EdgeInsets.all(0),
                                              icon: Icon(
                                                Icons.person,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                size: 20,
                                              ),
                                              onPressed: () {},
                                            )
                                          : Image.network(
                                              snapshot.data!.docs[index]
                                                  ['photoUrl'],
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    snapshot.data!.docs[index]['username'],
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 15,
                                        letterSpacing: 1.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.user,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ));
  }
}
