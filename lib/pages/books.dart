import 'package:bobok/utils/constants.dart';
import 'package:flutter/material.dart';

class Books extends StatefulWidget {
  const Books({Key? key}) : super(key: key);

  @override
  _BooksState createState() => _BooksState();
}

class _BooksState extends State<Books> {
  List<String> cards = ['Card 2', 'Card 1', 'Card 3'];
  int selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(top: 20, left: 0, child: buildCard(0, const Offset(-30, 0))),
        Positioned(
            top: 20,
            left: deviceWidth - 150,
            child: buildCard(2, const Offset(30, 0))),
        Positioned(
            top: 20,
            left: deviceWidth * 0.3,
            child: buildCard(1, const Offset(0, 0))),
      ],
    ));
  }

  Widget buildCard(int index, Offset offset) {
    return Draggable(
      data: index,
      feedback: Card(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Container(width: 100, height: 200, child: Text(cards[index])),
        ),
      ),
      childWhenDragging: Container(),
      onDragEnd: (details) {
        print(index);
        setState(() {
          final draggedCard = cards.removeAt(index);
          cards.insert(selectedIndex, draggedCard);
        });
      },
      child: Opacity(
        opacity: selectedIndex == index ? 1.0 : 0.7,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child:
                Container(width: 100, height: 200, child: Text(cards[index])),
          ),
        ),
      ),
    );
  }
}
