import 'package:bobok/models/review.dart';
import 'package:bobok/pages/profile.dart';
import 'package:flutter/material.dart';

class ProfileReview extends StatelessWidget {
  const ProfileReview({
    Key? key,
    required this.itemReview,
  }) : super(key: key);
  final Review itemReview;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 1,
      color: Theme.of(context).colorScheme.onBackground,
      child: Stack(
        children: [
          Container(
              width: 200,
              height: 200,
              child: Image.network(
                itemReview.imageUrl,
                cacheHeight: 150,
                cacheWidth: 110,
                fit: BoxFit.fill,
                color: Colors.black
                    .withOpacity(0.7), // Aplica o efeito de escurecimento
                colorBlendMode: BlendMode
                    .darken, // Define o modo de mesclagem para escurecer a imagem
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Profile(uid: itemReview.uid, currentUid: false),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    itemReview.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  itemReview.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
