import 'package:flutter/material.dart';
import 'package:my_platzi/screens/login_screen.dart';
import 'package:my_platzi/theme/dark_theme.dart';
import 'package:my_platzi/theme/light_theme.dart';
import '../screens/main_screen.dart';
import 'package:provider/provider.dart';
import '../logics/textsize_logic.dart';
import '../logics/theme_logic.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    final themeLogic = Provider.of<ThemeLogic>(context, listen: false);
    final textSizeLogic = Provider.of<TextsizeLogic>(context, listen: false);
    
    await themeLogic.readTheme();
    await textSizeLogic.readFontSize();
  }

  @override
  Widget build(BuildContext context) {
    return Selector2<ThemeLogic, TextsizeLogic, Map<String, dynamic>>(
      selector: (context, themeLogic, textSizeLogic) {
        return {
          'themeIndex': themeLogic.themeIndex,
          'scaleIndex': textSizeLogic.scaleIndex,
        };
      },
      builder: (context, values, child) {
        return MaterialApp(
          initialRoute: "/",
          themeMode: values['themeIndex'] == 1
              ? ThemeMode.dark
              : values['themeIndex'] == 2
                  ? ThemeMode.light
                  : ThemeMode.system,
          theme: lightTheme(values['scaleIndex']),
          darkTheme: darkTheme(values['scaleIndex']),
          onGenerateRoute: (settings) {
            switch (settings.name) {
          case "/":
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case "/main_screen":
            return MaterialPageRoute(builder: (context) => MainScreen());
              default:
                return MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(title: const Text("Page Not Found")),
                    body: const Center(child: Text("Route might be wrong")),
                  ),
                  fullscreenDialog: true,
                  settings: settings,
                );
            }
          },
        );
      },
    );
  }
}