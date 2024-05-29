import 'package:flutter/material.dart';

class AnimatedContainerExample extends StatefulWidget {
  const AnimatedContainerExample({
    Key? key,
    required this.content,
  }) : super(key: key);

  final Widget content;

  @override
  AnimatedContainerExampleState createState() =>
      AnimatedContainerExampleState();
}

class AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  double _containerSize = 100.0;
  Color _containerColor = Colors.blue;
  IconData _iconData = Icons.add;

  void _changeContainer() {
    setState(() {
      if (_containerSize == 100.0) {
        _containerSize = 200.0;
        _containerColor = Colors.green;
        _iconData = Icons.check;
      } else {
        _containerSize = 100.0;
        _containerColor = Colors.blue;
        _iconData = Icons.add;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background.withOpacity(0.8),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      width: _containerSize,
      height: _containerSize,
      color: _containerColor,
      child: Icon(
        _iconData,
        color: Colors.white,
        size: 50.0,
      ),
    );
  }
}
