import 'package:bobok/wisgets/card/card_myfav.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:bobok/mobx/user_store.dart';

class MyList extends StatefulWidget {
  const MyList({super.key, this.userStore});
  final UserStore? userStore;

  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  String selectedTab = 'Livro';
  late AutoScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );

    print(widget.userStore?.user?.myfav);
  }

  List getFilteredMyFav() {
    if (widget.userStore?.user?.myfav == null) {
      return [];
    }

    return widget.userStore!.user!.myfav!.where((item) {
      return item['category'] == selectedTab;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.background),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Minha Lista',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  buildTab('Livro', index: 0),
                  buildTab('Manga', index: 1),
                  buildTab('HQ', index: 2),
                  buildTab('Filme', index: 3),
                  buildTab('Série', index: 4),
                  buildTab('Anime', index: 5),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: getFilteredMyFav().length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: (2.8 / 4),
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                    ),
                    itemBuilder: (ctx, i) =>
                        CardMyFav(fav: getFilteredMyFav()[i])),
              ),
            ),
          ],
        ));
  }

  Widget buildTab(String tabName, {required int index}) {
    bool isSelected = selectedTab == tabName;

    return AutoScrollTag(
      key: ValueKey(index),
      controller: _scrollController,
      index: index,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = tabName;
          });
          _scrollController.scrollToIndex(index,
              preferPosition: AutoScrollPosition.begin);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(isSelected ? 0 : 12),
              bottomRight: Radius.circular(isSelected ? 0 : 12),
            ),
          ),
          child: Text(
            tabName,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.primary,
              letterSpacing: 0.5,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
