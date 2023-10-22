import 'package:bobok/utils/constants.dart';
import 'package:bobok/wisgets/animated/comments_container.dart';
import 'package:flutter/material.dart';

class ReviewDetail extends StatefulWidget {
  const ReviewDetail({
    super.key,
  });

  @override
  State<ReviewDetail> createState() => _ReviewDetailState();
}

class _ReviewDetailState extends State<ReviewDetail> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          arguments['title'],
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 25,
              letterSpacing: 1.5),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.primary,
        titleSpacing: 5,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: deviceHeight,
              width: deviceWidth,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.7),
              ),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Expanded(
                  child: Container(
                    height: deviceHeight * 0.9,
                    width: deviceWidth,
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.85),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 35,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    child: arguments['profileImg'] == null
                                        ? IconButton(
                                            padding: const EdgeInsets.all(0),
                                            icon: Icon(
                                              Icons.person,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              size: 40,
                                            ),
                                            onPressed: () {},
                                          )
                                        : Image.network(arguments['profileImg'],
                                            fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  arguments['userName'],
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 20,
                                      letterSpacing: 1.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Resenha: '.toUpperCase(),
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 18,
                                  letterSpacing: 1.5),
                            ),
                          ),
                        ),
                        arguments['isComment'] == false
                            ? Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 0, 3),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        arguments['review'],
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: deviceHeight * 0.1,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 0, 3),
                                            child: Text(
                                              arguments['review'],
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(50, 30),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 3),
                                        child: Text(
                                          "ver mais...",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontSize: 15,
                                              letterSpacing: 1.5),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          arguments['isComment'] = false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                        arguments['isComment'] == false
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 35,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.star_border_rounded,
                                        size: 25,
                                      ),
                                      tooltip: 'Show Snackbar',
                                      onPressed: () {
                                        print("sdasd");
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.messenger_outline,
                                        size: 20,
                                      ),
                                      tooltip: 'Show Snackbar',
                                      onPressed: () {
                                        setState(() {
                                          arguments['isComment'] = true;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.share,
                                        size: 20,
                                      ),
                                      tooltip: 'Show Snackbar',
                                      onPressed: () {
                                        print("sdasd");
                                      },
                                    ),
                                  )
                                ],
                              )
                            : Expanded(
                                child: CommentsCard(
                                    avatar: arguments['currentUserPhoto'],
                                    userUid: arguments['userUid'],
                                    postId: arguments['postId'],
                                    userName: arguments['currentUserName']),
                              )
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
