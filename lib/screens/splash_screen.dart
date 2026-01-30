import 'package:flutter/material.dart';
import 'package:my_platzi/apps/my_app.dart';
import 'package:my_platzi/logics/category_logic.dart';
import 'package:my_platzi/logics/product_logic.dart';
import 'package:my_platzi/logics/textsize_logic.dart';
import 'package:my_platzi/logics/theme_logic.dart';
import 'package:my_platzi/widgets/my_error.dart';
import 'package:my_platzi/widgets/my_logo.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future? _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _loadData();
  }

  Future _loadData() async {
    // ដាក់ Loading ចំនូន ២ វិនាទី
    final productLogic = context.read<ProductLogic>();
    final categoryLogic = context.read<CategoryLogic>();
    // final themelogic = context.read<ThemeLogic>();
    // final textsizelogic = context.read<TextsizeLogic>();
    await Future.delayed(Duration(seconds: 2), () {});
    // ignore: use_build_context_synchronously
    return Future.any([
      productLogic.readProductPagination(),
      categoryLogic.read(),
      context.read<ThemeLogic>().readTheme(),
      context.read<TextsizeLogic>().readFontSize(),
      // themelogic.readTheme(),
      // textsizelogic.readFontSize(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _futureData == null
          ? MyLogo(context)
          : FutureBuilder(
              future: _futureData,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return MyError(
                    context,
                    error: snapshot.error.toString(),
                    onPressed: () {
                      setState(() {
                        _futureData = _loadData();
                      });
                    },
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return MyApp();
                } else {
                  return MyLogo(context);
                }
              },
            ),
    );
  }
}
