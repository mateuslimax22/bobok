import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardComment extends StatefulWidget {
  const CardComment({
    super.key,
    required this.snap,
  });

  final snap;

  @override
  State<CardComment> createState() => _CardCommentState();
}

class _CardCommentState extends State<CardComment> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          Column(
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
                            color: Theme.of(context).colorScheme.onPrimary,
                          )),
                      TextSpan(
                          text: ' ${widget.snap.data()['text']}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
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
        ],
      ),
    );
  }
}
