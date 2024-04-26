import 'package:flutter/material.dart';
import './services/auth_service.dart';
import './services/database_service.dart';
import './services/preferences_service.dart';
import './screens/sign_in_screen.dart';
import './screens/sign_up_screen.dart';
import './screens/list_screen.dart';

void main() {
  runApp(ShopEaseApp());
}

class ShopEaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        './sign_in_screen.dart': (context) => SignInScreen(),
        './sign_up_screen.dart': (context) => SignUpScreen(),
        './screens/list_screen.dart': (context) => ListScreen(),
      },
    );
  }
}
