import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class TextsizeLogic extends ChangeNotifier {
  // ignore: non_constant_identifier_names
  static final MIN_SCALE = 1;
  // ignore: non_constant_identifier_names
  static final MAX_SCALE = 10;

  final _key = "TextsizeLogic";
  final _storage = FlutterSecureStorage();

  int _scaleIndex = MIN_SCALE;
  int get scaleIndex => _scaleIndex;
  
  final logger = Logger();

  Future readFontSize() async {
    String index = await _storage.read(key: _key) ?? MIN_SCALE.toString();
    _scaleIndex = int.parse(index);
    if (_scaleIndex < MIN_SCALE) {
      _scaleIndex = MIN_SCALE;
    }
    if (_scaleIndex > MAX_SCALE) {
      _scaleIndex = MAX_SCALE;
    }
    notifyListeners();
  }

  void changeScaleIndex(int index) {
    if (index < MIN_SCALE) {
      index = MIN_SCALE;
    }
    if (index > MAX_SCALE) {
      index = MAX_SCALE;
    }
    _storage.write(key: _key, value: index.toString());

    _scaleIndex = index;
     logger.i("$_scaleIndex");
    notifyListeners();
  }
}
