import 'package:app/auth/confirmpin.dart';
import 'package:flutter/material.dart';
import 'info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Spalsh extends StatefulWidget {
  const Spalsh({Key? key}) : super(key: key);

  @override
  State<Spalsh> createState() => _SpalshState();
}

class _SpalshState extends State<Spalsh> {
  String token = '';
  @override
  void initState() {
    super.initState();
    getData();
    _navigationHome();
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // ignore: unused_local_variable
      final token = prefs.getString('token');
      print(token);
    });
  }

  _navigationHome() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    await Future.delayed(Duration(milliseconds: 3000), () {
      print(token);
      if (token!.isEmpty) {
        Navigator.pushReplacement(
            context,
            // ignore: prefer_const_constructors
            MaterialPageRoute(builder: (context) => Info(Builder)));
      } else {
        Navigator.pushReplacement(
            context,
            // ignore: prefer_const_constructors
            MaterialPageRoute(builder: (context) => ConfirmPin()));
      }
    });
    // ignore: use_build_context_synchronously
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: Center(
          child: Image(
        image: AssetImage(
          'assets/cardri2.png',
        ),
        width: 140,
      )),
    );
  }
}
