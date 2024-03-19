import 'package:flutter/material.dart';

class WatchOnlineButtonWidget extends StatelessWidget {
  static const _width = 300.0;
  static const _height = 60.0;

  final void Function() onPressed;

  const WatchOnlineButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: _width,
        height: _height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Container(
                height: _height,
                width: _width,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Watch Online",
                      style: textStyle,
                    ),
                    Icon(
                      Icons.arrow_downward,
                      color: textStyle?.color,
                    )
                  ],
                ),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
