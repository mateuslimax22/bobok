// ignore_for_file: dead_code

import 'package:bobok/data/dummy_data.dart';
import 'package:bobok/mobx/user_store.dart';
import 'package:bobok/models/review.dart';
import 'package:bobok/wisgets/card/profile_review.dart';
import 'package:bobok/wisgets/listCard/list_card_top5.dart';
import 'package:bobok/wisgets/listCard/list_card_world.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class World extends StatefulWidget {
  const World({super.key, this.userStore, this.uid});
  final UserStore? userStore;
  final String? uid;

  @override
  State<World> createState() => _World();
}

class _World extends State<World> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            Column(
              children: [
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
                                    child: ListCardTop5(
                                  uid: widget.uid,
                                  userId: widget.uid,
                                )),
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
                                    child: ListCardWorld(
                                        userStore: widget.userStore)),
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
