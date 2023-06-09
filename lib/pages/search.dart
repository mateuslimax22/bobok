import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _Search();
}

class _Search extends State<Search> {
  final TextEditingController _textEditingController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    _textEditingController
        .dispose(); // Lembre-se de liberar o controller quando não for mais necessário.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.primary,
          titleSpacing: 5,
          title: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(labelText: 'Pesquisar usuário'),
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
                      'username',
                      isGreaterThanOrEqualTo: _textEditingController.text,
                    )
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
                                                  .background,
                                              size: 80,
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
                        );
                      });
                },
              )
            : const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Usuários"),
              ));
  }
}
