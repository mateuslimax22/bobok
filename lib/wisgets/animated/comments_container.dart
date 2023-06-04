import 'package:bobok/utils/constants.dart';
import 'package:flutter/material.dart';

class CommentsCard extends StatefulWidget {
  const CommentsCard({super.key});

  @override
  State<CommentsCard> createState() => _CommentsCard();
}

class _CommentsCard extends State<CommentsCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Theme.of(context).colorScheme.background,
                  Theme.of(context).colorScheme.inverseSurface,
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20))),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          height: deviceHeight * 0.60,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Comentários"),
              ],
            ),
          ),
        ),
        SizedBox(
          height: deviceHeight * 0.07,
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
              Expanded(
                child: TextField(
                  decoration:
                      InputDecoration(hintText: "Adicione um comentário"),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
