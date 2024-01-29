import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MyList extends StatefulWidget {
  const MyList({super.key});

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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'Conteúdo da aba $selectedTab aqui.',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
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
