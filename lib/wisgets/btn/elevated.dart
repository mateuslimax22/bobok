import 'package:flutter/material.dart';

class ElevatedButtonTh extends StatefulWidget {
  const ElevatedButtonTh({
    Key? key,
    required this.label,
    required this.target,
    required this.fontSize,
    required this.fontWeight,
    required this.width,
    required this.height,
  }) : super(key: key);

  final String label;
  final Function() target;
  final double fontSize;
  final FontWeight fontWeight;
  final double width;
  final double height;

  @override
  State<ElevatedButtonTh> createState() => _ElevatedButtonThState();
}

class _ElevatedButtonThState extends State<ElevatedButtonTh> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Theme.of(context).colorScheme.primary,
            minimumSize: Size(widget.width, widget.height)),
        onPressed: widget.target,
        child: Text(
          widget.label,
          style: TextStyle(
              color: Theme.of(context).colorScheme.background,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
              letterSpacing: 1.5),
        ),
      ),
    );
  }
}
