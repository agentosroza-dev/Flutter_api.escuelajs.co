import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
class ThemeLogic extends ChangeNotifier{
  final logger = Logger();
  final _key = "ThemeLogic";
  final _storage = FlutterSecureStorage();

  int _themeIndex = 0;
  int get themeIndex => _themeIndex;

  Future readTheme() async{
    String index = await _storage.read(key: _key) ?? "0";
    _themeIndex = int.parse(index);
    logger.i("$_themeIndex");
    notifyListeners();
  }

  void changeToSystem(){
    _themeIndex = 0;
    _storage.write(key: _key, value:  _themeIndex.toString());
    logger.i("$_themeIndex");
    notifyListeners();
  }

  void changeToDark(){
    _themeIndex = 1;
    _storage.write(key: _key, value:  _themeIndex.toString());
    logger.i("$_themeIndex");
    notifyListeners();
  }

  void changeToLight(){
    _themeIndex = 2;
    _storage.write(key: _key, value:  _themeIndex.toString());
    logger.i("$_themeIndex");
    notifyListeners();
  }
}