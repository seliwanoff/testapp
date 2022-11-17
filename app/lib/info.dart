// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages

class Info extends StatefulWidget {
  const Info(builder, {Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/illustration.png'),
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Receive money and Pay your bill without stress',
                        style: TextStyle(fontSize: 20, fontFamily: 'Ubuntu'),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    child: FlatButton(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Colors.blue[700],
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 1,
                              color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    child: FlatButton(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Colors.lightBlue[100],
                        onPressed: () {
                          // print('object');
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 1,
                              color: Colors.blue[700]),
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
