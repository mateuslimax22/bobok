import 'package:flutter/material.dart';

class ElevatedButtonTh extends StatefulWidget {
  const ElevatedButtonTh({
    super.key,
    required this.label,
    required this.target,
    required this.fontSize,
    required this.fontWeight,
    required this.width,
    required this.height,
    required this.progress,
  });

  final String label;
  final Function() target;
  final double fontSize;
  final FontWeight fontWeight;
  final double width;
  final double height;
  final bool progress;

  @override
  State<ElevatedButtonTh> createState() => _ElevatedButtonThState();
}

class _ElevatedButtonThState extends State<ElevatedButtonTh> {
  bool _loading = false; // Estado do progresso

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          minimumSize: Size(widget.width, widget.height),
        ),
        onPressed: widget.progress
            ? () {
                setState(() {
                  _loading =
                      true; // Ativa o progresso quando o botão for clicado
                });
                widget.target();
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    _loading = false;
                  });
                });
              }
            : widget.target,
        child: _loading // Verifica se o progresso está ativo
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context)
                    .colorScheme
                    .tertiary)) // Exibe o indicador de progresso
            : Text(
                widget.label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,
                  letterSpacing: 1.5,
                ),
              ),
      ),
    );
  }
}
