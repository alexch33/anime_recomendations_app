import 'package:flutter/material.dart';

Widget buildGenres(List<String> ganres, { trim: true }) {
  if (ganres.length > 6 && trim) {
    ganres = ganres.sublist(0, 6);
    ganres.add("  ...  ");
  }
  return Wrap(direction: Axis.horizontal, children: [
    ...ganres
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
        .toList()
  ]);
}
