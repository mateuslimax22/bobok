import 'package:bobok/utils/constants.dart';
import 'package:flutter/material.dart';

class CardAds extends StatefulWidget {
  const CardAds({
    Key? key,
    required this.colorback,
    required this.ads,
  }) : super(key: key);
  final Widget ads;
  final Color colorback;

  @override
  State<CardAds> createState() => _CardAdsState();
}

class _CardAdsState extends State<CardAds> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      elevation: 1,
      color: widget.colorback,
      child: SizedBox(
        width: deviceWidth,
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(10), // Image radius
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
                                    icon: Icon(
                                      Icons.account_balance_wallet_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 30,
                                    ),
                                    onPressed: () {},
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              'Ads',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 15,
                                  letterSpacing: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 35,
                      child: IconButton(
                        color: Theme.of(context).colorScheme.primary,
                        iconSize: 20,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert_outlined,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 200,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                minHeight: 180,
                                minWidth: deviceWidth * 0.5,
                                maxWidth: deviceWidth * 0.95,
                                maxHeight: 200,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
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
                              child: widget.ads,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
