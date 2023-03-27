import 'package:flutter_lorem/flutter_lorem.dart';

class GlobalFunc {
  static String textLorem(rows, words) {
    return lorem(paragraphs: rows, words: words);
  }
}
