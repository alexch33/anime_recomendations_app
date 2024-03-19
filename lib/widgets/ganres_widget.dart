import 'package:flutter/material.dart';

class GenresWidget extends StatelessWidget {
  final List<String> ganres;
  final bool trim;

  const GenresWidget({Key? key, required this.ganres, this.trim = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tmpganres = [];
    if (ganres.length > 6 && trim) {
      tmpganres = ganres.sublist(0, 6);
      tmpganres.add("  ...  ");
    }
    return Wrap(
        direction: Axis.horizontal,
        children: tmpganres
            .map((anime) => Padding(
                padding: EdgeInsets.all(1),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: Padding(
                      padding: EdgeInsets.all(1),
                      child: Text('  $anime  '),
                    ))))
            .toList());
  }
}
