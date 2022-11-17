// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:footer/footer.dart';
import 'package:http/http.dart';
import 'package:footer/footer_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/shared/loading.dart';

class Dashbaord extends StatefulWidget {
  const Dashbaord({Key? key}) : super(key: key);

  @override
  State<Dashbaord> createState() => _DashbaordState();
}

class _DashbaordState extends State<Dashbaord> {
  String token = '';
  String usename = '';
  String balance = '';
  String naira = '';
  bool loading = true;
  //final url = dotenv.get('API_URL');
  final myurl = Uri.parse(
    dotenv.get('API_URL') + 'api/getdatils',
  );
  final prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    getData();
    getUserDetails();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token')!;
    });
  }

  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;

    try {
      Response response = await get(myurl, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + token,
        'Content-Type': 'application/json'
      });
      var jsondata = jsonDecode(response.body);

      setState(() {
        usename = jsondata['data']['username'];
        balance = jsondata['data']['balance'];
        loading = false;
      });
      //print(response.body);
    } catch (e) {
      setState(() {
        loading = true;
      });
    }
  }

  late double height;
  Widget build(BuildContext context) {
    height = (MediaQuery.of(context).size.height);
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    CircleAvatar(
                        backgroundImage: AssetImage('assets/avater.jpg')),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Hi $usename',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: 'Ubuntu',
                          letterSpacing: 1),
                    )
                  ]),
                  Icon(Icons.notifications_active),
                ],
              ),
            ),
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                  canvasColor: Colors.white,
                  //  primaryColor: Colors.black,
                  unselectedWidgetColor: Colors.black,
                  selectedRowColor: Colors.yellow,
                  textTheme: Theme.of(context).textTheme.copyWith(
                      caption: TextStyle(
                          color: Colors.black, fontFamily: 'Ubuntu'))),
              child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  elevation: 20.0,
                  items: [
                    BottomNavigationBarItem(
                      icon: AnimatedContainer(
                        duration: Duration(milliseconds: 3000),
                        child: Icon(
                          Icons.history,
                        ),
                      ),
                      label: 'Transaction',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.card_giftcard), label: 'Cards'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.money), label: 'Loan'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: 'Profile')
                  ]),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await getUserDetails();
              },
              child: ListView(children: [
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: height - 23,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(0),
                                  height: 200,
                                  child: Card(
                                    color: Colors.blue[700],
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      'Total balance',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          letterSpacing: 0.5,
                                                          fontFamily: 'Ubuntu'),
                                                    ),
                                                    SizedBox(
                                                      height: 7,
                                                    ),
                                                    Text(
                                                      '₦' + balance,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Ubuntu'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/addmoney');
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3)),
                                                              child: Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .blue[700],
                                                              )),
                                                          SizedBox(
                                                            height: 2,
                                                          ),
                                                          Text(
                                                            'Add money',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontFamily:
                                                                    'Ubuntu'),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/transfer');
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3)),
                                                              child: Icon(
                                                                Icons
                                                                    .account_balance,
                                                                color: Colors
                                                                    .blue[700],
                                                              )),
                                                          SizedBox(
                                                            height: 2,
                                                          ),
                                                          Text(
                                                            'Transfer',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontFamily:
                                                                    'Ubuntu'),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/withdraw');
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3)),
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_upward,
                                                                color: Colors
                                                                    .blue[700],
                                                              )),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text(
                                                            'withdraw',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontFamily:
                                                                    'Ubuntu'),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: []),
                                  child: Image(
                                      image: AssetImage('assets/ad3.png'),
                                      width: double.infinity,
                                      height: double.infinity),
                                )),
                            SizedBox(
                              height: 0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'payment',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Ubuntu',
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context, '/data');
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.blue[100],
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Colors.blue),
                                              ),
                                              child: Icon(
                                                Icons.phone_android,
                                                color: Colors.blue[700],
                                                size: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              'Data',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  letterSpacing: 1,
                                                  fontFamily: 'Ubuntu'),
                                            )
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/airtime');
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.blue[100],
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Colors.blue),
                                              ),
                                              child: Icon(
                                                Icons.phone_android,
                                                color: Colors.blue[700],
                                                size: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              'Airtime',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  letterSpacing: 1,
                                                  fontFamily: 'Ubuntu'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: Colors.blue[100],
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                  width: 2, color: Colors.blue),
                                            ),
                                            child: Icon(
                                              Icons.tv_outlined,
                                              color: Colors.blue[700],
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            'Tv',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: 1,
                                                fontFamily: 'Ubuntu'),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.blue[100],
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                  width: 2, color: Colors.blue),
                                            ),
                                            child: Icon(
                                              Icons.lightbulb_sharp,
                                              color: Colors.blue[700],
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            'Electricity',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: 1,
                                                fontFamily: 'Ubuntu'),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.blue[100],
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                  width: 2, color: Colors.blue),
                                            ),
                                            child: Icon(
                                              Icons.sports_football,
                                              color: Colors.blue[700],
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            'betting',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: 1,
                                                fontFamily: 'Ubuntu'),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.blue[100],
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                  width: 2, color: Colors.blue),
                                            ),
                                            child: Icon(
                                              Icons.book,
                                              color: Colors.blue[700],
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            'Education',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: 1,
                                                fontFamily: 'Ubuntu'),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: Colors.blue[100],
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                  width: 2, color: Colors.blue),
                                            ),
                                            child: Icon(
                                              Icons.currency_exchange,
                                              color: Colors.blue[700],
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            'Airtime To cash',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: 1,
                                                fontFamily: 'Ubuntu'),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.blue[100],
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                  width: 2, color: Colors.blue),
                                            ),
                                            child: Icon(
                                              Icons.verified_user_sharp,
                                              color: Colors.blue[700],
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            'Referral',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                letterSpacing: 1,
                                                fontFamily: 'Ubuntu'),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          );
  }
}
