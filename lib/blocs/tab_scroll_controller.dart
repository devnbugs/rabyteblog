import 'package:flutter/material.dart';

class TabScrollController {
  bool isEnd(ScrollController sc) {
    var isEnd = sc.offset >= sc.position.maxScrollExtent && !sc.position.outOfRange;
    return isEnd;
  }
}
