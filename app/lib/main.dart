// ignore_for_file: prefer_const_constructors, invalid_use_of_visible_for_testing_member

import 'services/data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'panel/dashboard.dart';
import 'checkout/checkout.dart';
import 'loading.dart';
import 'splash.dart';
import 'package:app/services/airtime.dart';

void main() async {
  Map<String, Object> token = <String, Object>{'token': ''};
  SharedPreferences.setMockInitialValues(token);
  await dotenv.load(fileName: '.env');
  runApp(
    MaterialApp(
      initialRoute: '/splash',
      routes: {
        '/': (context) => Loading(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/dashboard': (context) => Dashbaord(),
        '/data': (context) => Data(),
        '/airtime': (context) => Airtime(),
        '/splash': (context) => Spalsh(),
        '/checkout': (context) => Checkout()
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}
