import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/loading.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isnotbuttonActivate = false;
  bool loading = false;
  bool status = false;
  String message = '';
  bool error = false;
  String btntext = 'Login';
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  logIn() async {
    setState(() {
      btntext = 'Loading';
      loading = true;
    });
    final url = dotenv.get('API_URL');
    final myurl = Uri.parse(url + 'api/auth/login');
    final data = {'id': idController.text, 'password': passwordController.text};

    if (data['id']!.isEmpty && data['password']!.isEmpty) {
      setState(() {
        status = false;
        error = true;
        message = 'All fields required';
        Future.delayed(Duration(milliseconds: 3000), () {
          setState(() {
            error = false;
            btntext = 'Login';
          });
        });
      });
    } else {
      try {
        Response response = await post(
          myurl,
          body: data,
        );
        var getrepsonse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', getrepsonse['token']);
          setState(() {
            status = true;
            error = true;
            loading = true;
            message = 'Login Success';
            Future.delayed(Duration(milliseconds: 1000), () {
              setState(() {
                error = false;
                btntext = 'Login';
              });

              Navigator.pushNamed(context, '/dashboard');
            });
          });
        } else {
          setState(() {
            status = false;
            error = true;
            loading = false;
            message = 'Incorrect credentials';
            Future.delayed(Duration(milliseconds: 3000), () {
              setState(() {
                error = false;
                btntext = 'Login';
              });
            });
          });
        }
      } catch (e) {
        setState(() {
          error = true;
          status = false;
          loading = false;
          message = 'Connection Problem';
          Future.delayed(Duration(milliseconds: 3000), () {
            setState(() {
              error = false;
              btntext = 'Login';
            });
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Container(
                child: Column(children: [
              SizedBox(
                height: 100,
              ),
              Row(
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ubuntu'),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Column(children: [
                Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        error
                            ? Container(
                                width: double.infinity,
                                color: status ? Colors.green : Colors.red,
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'Ubuntu'),
                                ),
                              )
                            : Text(' '),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: idController,
                          keyboardType: TextInputType.emailAddress,
                          enableSuggestions: true,
                          decoration: InputDecoration(
                              labelText: 'Username Or Number ',
                              hintText: 'Enter Your Number Or Username',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.blue[100]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          enableSuggestions: true,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter Your Password',
                              border: OutlineInputBorder(),
                              //  focusColor: Colors.red,
                              filled: true,
                              fillColor: Colors.blue[100]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password ?',
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        )
                      ]),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            child: FlatButton(
                              onPressed: logIn,
                              disabledColor: Color.fromARGB(255, 248, 244, 244),
                              child: Text(
                                '$btntext',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              color: Colors.blue[700],
                              padding: EdgeInsets.all(15),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ]),
            ])),
          ),
        )));
  }
}
