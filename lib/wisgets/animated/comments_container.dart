import 'package:bobok/provider/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../card/card_comment.dart';

class CommentsCard extends StatefulWidget {
  const CommentsCard({
    super.key,
    required this.avatar,
    required this.postId,
    required this.userUid,
    required this.userName,
  });
  final String? avatar;
  final String postId;
  final String userName;
  final userUid;

  @override
  State<CommentsCard> createState() => _CommentsCard();
}

class _CommentsCard extends State<CommentsCard> {
  TextEditingController _textEditingController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    _textEditingController
        .dispose(); // Lembre-se de liberar o controller quando não for mais necessário.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 3.0,
            ),
          ),
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.onError),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('reviews')
                        .doc(widget.postId)
                        .collection('comments')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Text(
                          "Nenhum comentário",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 14,
                              letterSpacing: 1.5),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return CardComment(
                            snap: snapshot.data!.docs[index],
                          );
                        },
                      );
                    })),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 45,
                    height: 35,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child: widget.avatar == null
                            ? IconButton(
                                padding: const EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.person,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  size: 40,
                                ),
                                onPressed: () {},
                              )
                            : Image.network(widget.avatar!, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                            hintText: "Adicione um comentário",
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_outlined),
                    onPressed: () async {
                      await FirestoreMethods().postComment(
                          widget.postId,
                          _textEditingController.text,
                          user.uid,
                          widget.userName,
                          widget.avatar!);
                      setState(() {
                        _textEditingController.text = '';
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
