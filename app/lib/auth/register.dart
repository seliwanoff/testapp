import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  signIn() async {
    print('hello clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
          //  const  physics = const BouncingScrollPhysics(),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_back_outlined,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Fill in your crendentials!',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
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
                            TextFormField(
                              keyboardType: TextInputType.text,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                  labelText: 'Firstname',
                                  hintText: 'Enter Your firstname',
                                  border: OutlineInputBorder()),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'correct';
                                } else {
                                  return 'Firstname required';
                                }
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                  labelText: 'lastname',
                                  hintText: 'Enter Your Lastname',
                                  border: OutlineInputBorder()),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'correct';
                                } else {
                                  return 'Email required';
                                }
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'Enter Your Email',
                                  border: OutlineInputBorder()),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'correct';
                                } else {
                                  return 'Email required';
                                }
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                  labelText: 'Username',
                                  hintText: 'Enter Your Username',
                                  border: OutlineInputBorder()),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'correct';
                                } else {
                                  return 'Username required';
                                }
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              obscureText: false,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                  labelText: 'Number',
                                  hintText: 'Enter Your Phone Number',
                                  border: OutlineInputBorder()),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'correct';
                                } else {
                                  return 'Phone Number required';
                                }
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Enter Your Password',
                                  border: OutlineInputBorder()),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'correct';
                                } else {
                                  return 'Password required';
                                }
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                  labelText: 'Referral',
                                  hintText: 'Enter Your Referral',
                                  border: OutlineInputBorder()),
                              validator: (value) {},
                            ),
                          ]),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FlatButton(
                                onPressed: signIn,
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                color: Colors.blue[700],
                                padding: EdgeInsets.all(15),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ]),
                ]),
          )),
    )));
  }
}
