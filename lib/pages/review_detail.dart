import 'package:bobok/models/review.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class ReviewDetail extends StatelessWidget {
  const ReviewDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Review review = ModalRoute.of(context)!.settings.arguments as Review;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          review.title,
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(review.imageUrl), fit: BoxFit.cover)),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.8),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.85),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 35,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  color: Theme.of(context).colorScheme.primary,
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
                                review.username,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 20,
                                    letterSpacing: 1.5),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 15, 0, 0),
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
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 15, 0, 3),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: SingleChildScrollView(
                                  child: Text(
                                    review.review,
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
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
