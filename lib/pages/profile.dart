// ignore_for_file: dead_code

import 'package:bobok/data/dummy_data.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/wisgets/btn/elevated.dart';
import 'package:bobok/wisgets/card/profile_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isEdit = false;
  String userName = "";
  void onChangedEdit() {
    setState(() {
      isEdit = !isEdit;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  final user = FirebaseAuth.instance.currentUser!;
  void getUserName() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    final List<Review> loadedReviewUser = dummyReviws;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Avaliadores",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 14,
                                        letterSpacing: 1.5),
                                  ),
                                  Text(
                                    "2000",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 20,
                                        letterSpacing: 1.5),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Leitores",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 14,
                                        letterSpacing: 1.5),
                                  ),
                                  Text(
                                    "20",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 20,
                                        letterSpacing: 1.5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 110,
                          width: 110,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: Container(
                                  padding:
                                      const EdgeInsets.all(4), // Border width
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: SizedBox(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: SizedBox.fromSize(
                                        size: const Size.fromRadius(
                                            48), // Image radius
                                        child: user.photoURL == null
                                            ? IconButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                icon: Icon(
                                                  Icons.person,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                                  size: 80,
                                                ),
                                                onPressed: () {},
                                              )
                                            : Image.network(user.photoURL!,
                                                fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (isEdit)
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: RawMaterialButton(
                                        onPressed: () {},
                                        elevation: 2.0,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ))
                              else
                                const SizedBox()
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButtonTh(
                                    label: 'Editar',
                                    target: onChangedEdit,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    width: 260,
                                    height: 30,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: SizedBox(
                                      child: Text(
                                        user.displayName!,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 20,
                                            letterSpacing: 1.5),
                                      ),
                                    ),
                                  ),
                                ]),
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Column(
                            children: [
                              const Text("Indicações"),
                              Expanded(
                                child: SizedBox(
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: loadedReviewUser.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: (2.8 / 4),
                                              crossAxisCount: 1,
                                              mainAxisSpacing: 2),
                                      itemBuilder: (ctx, i) => ProfileReview(
                                          itemReview: loadedReviewUser[i])),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            children: [
                              const Text("Resenhas"),
                              Expanded(
                                child: SizedBox(
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: loadedReviewUser.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: (2.8 / 4),
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 2,
                                              mainAxisSpacing: 2),
                                      itemBuilder: (ctx, i) => ProfileReview(
                                          itemReview: loadedReviewUser[i])),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
