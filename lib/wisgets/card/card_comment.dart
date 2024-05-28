import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/pages/profile.dart';
import 'package:bobok/provider/firestore_methods.dart';
import 'package:bobok/utils/constants.dart';
import 'package:bobok/wisgets/modal/delete_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CardComment extends StatefulWidget {
  const CardComment(
      {super.key,
      required this.snap,
      required this.userId,
      required this.postId,
      required this.userStore});
  final UserStore? userStore;
  final dynamic snap;
  final String userId;
  final String postId;

  @override
  State<CardComment> createState() => _CardCommentState();
}

class _CardCommentState extends State<CardComment> {
  // ignore: prefer_final_fields
  TextEditingController _textEditingController = TextEditingController();

  bool isEdit = false;
  bool isModalVisible = false;
  bool isExpanded = false;

  @override
  void dispose() {
    super.dispose();
    _textEditingController
        .dispose(); // Lembre-se de liberar o controller quando não for mais necessário.
  }

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String editComment = AppLocalizations.of(context)!.edtComm;
    final String deleteComment = AppLocalizations.of(context)!.dltComm;

    void menuAppbar(String value) {
      if (value == editComment) {
        setState(() {
          isEdit = !isEdit;
          _textEditingController.text = widget.snap.data()['text'].toString();
        });
      } else if (value == deleteComment) {
        setState(() {
          isModalVisible = true;
        });
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DeleteConfirmationModal(
              item: AppLocalizations.of(context)!.thiscomm,
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile(
                                    uid: widget.snap.data()['uid'],
                                    userStore: widget.userStore,
                                    currentUid: false),
                              ),
                            );
                          },
                        )
                      : GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile(
                                    uid: widget.snap.data()['uid'],
                                    userStore: widget.userStore,
                                    currentUid: false),
                              ),
                            )
                          },
                          child: Image.network(widget.snap.data()['profileImg'],
                              fit: BoxFit.cover),
                        ),
                ),
              ),
            ),
            isEdit
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                            child: TextField(
                              controller: _textEditingController,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
                : GestureDetector(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(
                              uid: widget.snap.data()['uid'],
                              userStore: widget.userStore,
                              currentUid: false),
                        ),
                      )
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.snap.data()['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: GestureDetector(
                                    onTap: toggleExpand,
                                    child: SizedBox(
                                      width: deviceWidth * 0.5,
                                      child: Text(
                                        ' ${widget.snap.data()['text']}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                        maxLines: isExpanded ? null : 2,
                                        overflow: isExpanded
                                            ? TextOverflow.visible
                                            : TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                                DateFormat.yMMMd().format(
                                  widget.snap.data()['datePublished'].toDate(),
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                )),
                          ]),
                    ),
                  ),
            const Spacer(),
            /*widget.snap.data()["uid"] == widget.userId
                ? PopupMenuButton<String>(
                    color: Theme.of(context).colorScheme.background,
                    onSelected: menuAppbar,
                    itemBuilder: (BuildContext context) {
                      return {
                        editComment,
                        deleteComment,
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
                    })}
                : */
            const SizedBox()
          ],
        ),
      ),
    );
  }
}
