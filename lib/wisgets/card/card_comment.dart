import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/wisgets/delete/delete_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardComment extends StatefulWidget {
  const CardComment({
    super.key,
    required this.snap,
    required this.userId,
    required this.postId,
  });

  final dynamic snap;
  final String userId;
  final String postId;

  @override
  State<CardComment> createState() => _CardCommentState();
}

class _CardCommentState extends State<CardComment> {
  TextEditingController _textEditingController = TextEditingController();

  bool isEdit = false;
  bool isModalVisible = false;

  void menuAppbar(String value) {
    switch (value) {
      case 'Editar comentário':
        setState(() {
          isEdit = !isEdit;
          _textEditingController.text = widget.snap.data()['text'].toString();
        });
        break;
      case 'Excluir comentário':
        setState(() {
          isModalVisible = true;
        });

        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController
        .dispose(); // Lembre-se de liberar o controller quando não for mais necessário.
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DeleteConfirmationModal(
            item: "este comentário",
            onDelete: () {
              FirestoreMethods().deleteComment(
                widget.postId,
                widget.snap.data()['commentId'],
              );
              setState(() {
                isModalVisible = false;
              });
            },
            isVisible: isModalVisible,
          ),
          SizedBox(
            width: 45,
            height: 35,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: widget.snap.data()['profileImg'] == null
                    ? IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                          size: 40,
                        ),
                        onPressed: () {},
                      )
                    : Image.network(widget.snap.data()['profileImg'],
                        fit: BoxFit.cover),
              ),
            ),
          ),
          isEdit
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                          child: TextField(
                            controller: _textEditingController,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 16,
                                letterSpacing: 1.5),
                            decoration: InputDecoration(
                                fillColor:
                                    Theme.of(context).colorScheme.primary,
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_right_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () async {
                          await FirestoreMethods().editComment(
                            widget.postId,
                            widget.snap.data()['commentId'],
                            _textEditingController.text,
                          );
                          setState(() {
                            _textEditingController.text = '';
                            isEdit = false;
                          });
                        },
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: widget.snap.data()['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                )),
                            TextSpan(
                                text: ' ${widget.snap.data()['text']}',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ))
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                            DateFormat.yMMMd().format(
                              widget.snap.data()['datePublished'].toDate(),
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.onPrimary,
                            )),
                      ),
                    ]),
          const Spacer(),
          widget.snap.data()["uid"] == widget.userId
              ? PopupMenuButton<String>(
                  color: Theme.of(context).colorScheme.background,
                  onSelected: menuAppbar,
                  itemBuilder: (BuildContext context) {
                    return {
                      'Editar comentário',
                      'Excluir comentário',
                    }.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(
                          choice,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 15,
                              letterSpacing: 1.5),
                        ),
                      );
                    }).toList();
                  })
              : const SizedBox()
        ],
      ),
    );
  }
}
