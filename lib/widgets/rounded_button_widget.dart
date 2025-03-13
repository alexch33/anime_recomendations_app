import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback onPressed;

  const RoundedButtonWidget({
    Key? key,
    this.buttonText = "",
    this.buttonColor = Colors.blue,
    this.textColor = Colors.white,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(StadiumBorder()),
        backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(color: textColor),
      ),
    );
  }
}
