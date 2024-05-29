import 'package:flutter/material.dart';

class ElevatedButtonTh extends StatelessWidget {
  const ElevatedButtonTh({
    Key? key,
    required this.label,
    required this.target,
    required this.fontSize,
    required this.fontWeight,
    required this.width,
    required this.height,
    required this.isLoading,
    this.backgroundColor, // Nova propriedade para a cor de fundo
  }) : super(key: key);

  final String label;
  final Function()? target;
  final double fontSize;
  final FontWeight fontWeight;
  final double width;
  final double height;
  final bool isLoading;
  final Color?
      backgroundColor; // Adicionando a cor de fundo como uma propriedade

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: backgroundColor ??
              Theme.of(context)
                  .colorScheme
                  .primary, // Usando a cor fornecida ou a cor primária padrão
          minimumSize: Size(width, height),
        ),
        onPressed: isLoading
            ? null
            : () {
                target?.call();
              },
        child: isLoading
            ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.tertiary),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  letterSpacing: 1.5,
                ),
              ),
      ),
    );
  }
}
