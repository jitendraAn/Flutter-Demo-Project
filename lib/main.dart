import 'package:flutter/material.dart';
import 'package:my_flutter_cocktail_app/Home/HomeScreen.dart';
import 'package:my_flutter_cocktail_app/login/LoginScreen.dart';
import 'package:my_flutter_cocktail_app/splash/SplashScreen.dart';
import 'package:my_flutter_cocktail_app/utils/Constraints.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constraints.preferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(primaryColor: Colors.red, accentColor: Colors.yellowAccent),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // initialRoute: '/',
      routes: {
        '/Login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        // '/cart': (context) => MyCart(),
      },
    );
  }
}
