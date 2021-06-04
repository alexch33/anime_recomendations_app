import 'package:flutter/material.dart';

class AdLabel extends StatelessWidget {
  final double padding;

  const AdLabel({
    Key? key,
    this.padding = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildAdRecommended();
  }

  Widget _buildAdRecommended() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Text("Ad"),
      ),
      decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.all(Radius.circular(16))),
    );
  }
}
