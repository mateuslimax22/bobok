import 'package:bobok/models/review.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          arguments['title'],
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 25,
              letterSpacing: 1.5),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        titleSpacing: 5,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: deviceHeight,
          width: deviceWidth,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(arguments['imageUrl']),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Container(
                height: deviceHeight,
                width: deviceWidth,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.background.withOpacity(0.7),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
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
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        iconSize: 40,
                                        onPressed: () {
                                          print("sdasd7");
                                        },
                                        icon: const Icon(
                                          Icons.account_box,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      arguments['userName'],
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontSize: 20,
                                          letterSpacing: 1.5),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Resenha: '.toUpperCase(),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 18,
                                        letterSpacing: 1.5),
                                  ),
                                ),
                              ),
                              arguments['isComment'] == false
                                  ? Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 0, 3),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: deviceHeight * 0.1,
                                          child: Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                        ),
                                        SizedBox(
                                          height: 20,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: const Size(50, 30),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  : CommentsCard()
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
