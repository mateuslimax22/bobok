import 'package:bobok/models/review.dart';
import 'package:bobok/utils/app_routes.dart';
import 'package:flutter/material.dart';

class CardReview extends StatelessWidget {
  const CardReview({
    Key? key,
    required this.colorback,
    required this.listReview,
  }) : super(key: key);
  final Review listReview;
  final Color colorback;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      elevation: 1,
      color: colorback,
      child: SizedBox(
        width: double.infinity,
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 35,
                          child: IconButton(
                            color: Theme.of(context).colorScheme.primary,
                            alignment: Alignment.bottomLeft,
                            iconSize: 30,
                            onPressed: () {
                              print("sdasd7");
                            },
                            icon: const Icon(
                              Icons.account_box,
                            ),
                          ),
                        ),
                        Text(
                          listReview.username,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 12,
                              letterSpacing: 1.5),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 40,
                      height: 35,
                      child: IconButton(
                        color: Theme.of(context).colorScheme.primary,
                        iconSize: 20,
                        onPressed: () {
                          print("sdasd");
                        },
                        icon: const Icon(
                          Icons.more_vert_outlined,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 205,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 0, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
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
                                        child: Image.network(
                                            listReview.imageUrl,
                                            width: 100,
                                            height: 150,
                                            fit: BoxFit.cover),
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            AppRoutes.REVIEW_DETAIL,
                                            arguments: listReview,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        listReview.title.toUpperCase(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontSize: 14,
                                            letterSpacing: 1.5),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Text(
                                        "Resenha: ".toUpperCase(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontSize: 10,
                                            letterSpacing: 1.5),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Expanded(
                                        child: Text(
                                          listReview.review.toUpperCase(),
                                          maxLines: 8,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontSize: 10,
                                              letterSpacing: 1.5),
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
                                        child: Text(
                                          "ver mais.".toUpperCase(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontSize: 10,
                                              letterSpacing: 1.5),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                            AppRoutes.REVIEW_DETAIL,
                                            arguments: listReview,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
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
                          print("sdasd");
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
