import 'package:flutter/material.dart';
import 'package:my_platzi/logics/category_logic.dart';
import 'package:provider/provider.dart';

import '../logics/product_logic.dart';
import '../logics/textsize_logic.dart';
import '../logics/theme_logic.dart';
import '../screens/splash_screen.dart';

// ignore: non_constant_identifier_names
Widget AppProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ProductLogic()),
      ChangeNotifierProvider(create: (context) => CategoryLogic()),
      ChangeNotifierProvider(create: (context) => ThemeLogic()),
      ChangeNotifierProvider(create: (context) => TextsizeLogic()),
    ],
    child: SplashScreen(),
  );
}
