import 'package:flutter/material.dart';

Widget buildGenres(List<String> ganres) {
  return Wrap(direction: Axis.horizontal, children: [
    ...ganres
        .map((anime) => Padding(
            padding: EdgeInsets.all(1),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: Text(anime),
                ))))
        .toList()
  ]);
}
