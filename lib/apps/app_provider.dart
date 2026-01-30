import 'package:flutter/material.dart';
import 'package:my_platzi/logics/category_logic.dart';
import '../logics/search_product_logic.dart';
import 'package:provider/provider.dart';

import '../logics/product_logic.dart';
import '../logics/textsize_logic.dart';
import '../logics/theme_logic.dart';
import '../screens/splash_screen.dart';

Widget appProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ProductLogic()),
      ChangeNotifierProvider(create: (context) => SearchProductLogic()),
      ChangeNotifierProvider(create: (context) => CategoryLogic()),
      ChangeNotifierProvider(create: (context) => ThemeLogic()),
      ChangeNotifierProvider(create: (context) => TextsizeLogic()),
    ],
    child: SplashScreen(),
  );
}
