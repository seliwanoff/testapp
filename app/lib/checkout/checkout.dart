import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:footer/footer_view.dart';
import 'package:footer/footer.dart';
import 'package:local_auth/local_auth.dart';
import 'package:app/shared/loading.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  num amount = 0;
  num commission = 0;
  String network = '';
  String networkname = '';
  String plan = '';
  String planid = '';
  String name = '';
  String usenrname = '';
  String status = '';
  String receiver = '';
  String date = '';
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSavedData();
    getDate();
    FingerPrint();
  }

  getDate() {
    setState(() {
      date = DateFormat('yyyyMMddkkmm').format(DateTime.now());
    });
  }

  getSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString('dataList') ?? '';
    Map<String, dynamic> map = jsonDecode(rawJson);
    print(map['amount']);
    setState(() {
      usenrname = map['username'];
      plan = map['plan'];
      planid = map['planid'];
      amount = map['amount'];
      commission = map['commission'];
      name = map['name'];
      status = '1';
      receiver = map['reciever'];
      loading = false;
    });
  }

  @override
  late double height;
  Widget build(BuildContext context) {
    height = (MediaQuery.of(context).size.height);

    return loading
        ? Loading()
        : Scaffold(
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
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Checkout',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w100,
                            fontSize: 13),
                      ),
                    ],
                  )
                ],
              ),
            ),
            body: Container(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        'Actual Payment',
                                        style: TextStyle(fontFamily: 'Ubuntu'),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Center(
                                      child: Text(
                                        NumberFormat.simpleCurrency(
                                                name: 'NGN', decimalDigits: 2)
                                            .format(amount),
                                        style: TextStyle(
                                          fontSize: 23,
                                          fontFamily: 'Ubuntu',
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 6,
                                            offset: Offset(-5, 0))
                                      ]),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Product name',
                                            style: TextStyle(
                                                fontFamily: 'Ubuntu',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            '${name}',
                                            style: TextStyle(
                                                fontFamily: 'Ubuntu',
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Fee',
                                            style: TextStyle(
                                                fontFamily: 'Ubuntu',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            NumberFormat.simpleCurrency(
                                                    name: 'NGN',
                                                    decimalDigits: 2)
                                                .format(amount),
                                            style: TextStyle(
                                                fontFamily: 'Ubuntu',
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 6,
                                            offset: Offset(-5, 0))
                                      ]),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Favourable',
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 2.5, 0, 4),
                                        decoration: BoxDecoration(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue[700],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Icon(
                                                    Icons.money,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Discount',
                                                  style: TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              NumberFormat.simpleCurrency(
                                                      name: 'NGN',
                                                      decimalDigits: 2)
                                                  .format(commission),
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 2.5, 0, 4),
                                        decoration: BoxDecoration(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue[700],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Icon(
                                                    Icons.money,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Commission',
                                                  style: TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              NumberFormat.simpleCurrency(
                                                      name: 'NGN',
                                                      decimalDigits: 2)
                                                  .format(commission),
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 2.5, 0, 0),
                                        decoration: BoxDecoration(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue[700],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Icon(
                                                    Icons.money,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Hash',
                                                  style: TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              date,
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 6,
                                            offset: Offset(-5, 0))
                                      ]),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 10),
                                        decoration: BoxDecoration(),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Product details',
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 2.5, 0, 4),
                                        decoration: BoxDecoration(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue[700],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Icon(
                                                    Icons.money,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Receiver',
                                                  style: TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${receiver}',
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 2.5, 0, 4),
                                        decoration: BoxDecoration(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue[700],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Icon(
                                                    Icons.money,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Plan',
                                                  style: TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${plan}',
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 2.5, 0, 0),
                                        decoration: BoxDecoration(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue[700],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Icon(
                                                    Icons.money,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Channel',
                                                  style: TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '2',
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FlatButton(
                                color: Colors.blue[700],
                                padding: EdgeInsets.all(12),
                                onPressed: () {
                                  bottomsheet(context);
                                },
                                child: Text(
                                  'Pay',
                                  style: TextStyle(
                                      fontFamily: 'Ubuntu',
                                      fontSize: 15,
                                      color: Colors.white),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

void bottomsheet(context) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: OtpScreen(),
          ));
}

class OtpScreen extends StatefulWidget {
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  List<String> currentPin = ["", "", "", ""];
  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();

  var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Color.fromARGB(255, 197, 226, 240)));

  int PinIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              BuildSecurityText(),
              SizedBox(
                height: 10.0,
              ),
              buildPinRow()
            ]),
          ),
          SizedBox(
            height: 15,
          ),
          buildNumberPad()
        ],
      ),
    );
  }

  pinIndexSetup(text) {
    if (PinIndex == 0)
      print(PinIndex);
    else if (PinIndex < 4) print(PinIndex);

    PinIndex++;
    setPin(PinIndex, text);
    currentPin[PinIndex - 1] = text;
    String strPin = "";
    currentPin.forEach((e) {
      strPin += e;
    });

    if (PinIndex == 4) print(strPin);
  }

  setPin(int n, String text) {
    switch (n) {
      case 1:
        pinOneController.text = text;
        break;
      case 2:
        pinTwoController.text = text;
        break;
      case 3:
        pinThreeController.text = text;
        break;
      case 4:
        pinFourController.text = text;
        break;
    }
  }

  buildNumberPad() {
    return Expanded(
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                      n: 1,
                      onPressed: () {
                        pinIndexSetup('1');
                      }),
                  KeyboardNumber(
                      n: 2,
                      onPressed: () {
                        pinIndexSetup('2');
                      }),
                  KeyboardNumber(
                      n: 3,
                      onPressed: () {
                        pinIndexSetup('3');
                      })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                      n: 4,
                      onPressed: () {
                        pinIndexSetup('4');
                      }),
                  KeyboardNumber(
                      n: 5,
                      onPressed: () {
                        pinIndexSetup('5');
                      }),
                  KeyboardNumber(
                      n: 6,
                      onPressed: () {
                        pinIndexSetup('6');
                      })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                      n: 7,
                      onPressed: () {
                        pinIndexSetup('7');
                      }),
                  KeyboardNumber(
                      n: 8,
                      onPressed: () {
                        pinIndexSetup('8');
                      }),
                  KeyboardNumber(
                      n: 9,
                      onPressed: () {
                        pinIndexSetup('9');
                      })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 60,
                    child: MaterialButton(
                      onPressed: () {
                        FingerPrint.authenticate();
                      },
                      child: Icon(
                        Icons.fingerprint,
                        size: 40,
                      ),
                    ),
                  ),
                  KeyboardNumber(
                      n: 0,
                      onPressed: () {
                        pinIndexSetup('0');
                      }),
                  Container(
                    width: 60,
                    child: MaterialButton(
                      onPressed: () {
                        clearPin();
                      },
                      child: Image(
                        image: AssetImage('assets/clear.png'),
                        width: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  clearPin() {
    if (PinIndex == 0) {
      print(PinIndex);
    } else if (PinIndex == 4) {
      setPin(PinIndex, "");
      currentPin[PinIndex - 1] = '';
      PinIndex--;
    } else {
      setPin(PinIndex, "");
      currentPin[PinIndex - 1] = "";
      PinIndex--;
    }
  }

  buildPinRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PINNumber(
            textEditingController: pinOneController,
            outlineInputBorder: outlineInputBorder),
        PINNumber(
            textEditingController: pinTwoController,
            outlineInputBorder: outlineInputBorder),
        PINNumber(
            textEditingController: pinThreeController,
            outlineInputBorder: outlineInputBorder),
        PINNumber(
            textEditingController: pinFourController,
            outlineInputBorder: outlineInputBorder)
      ],
    );
  }

  BuildSecurityText() {
    return Text(
      'Enter Your PIN',
      style: TextStyle(
          color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w600),
    );
  }

  BuildExitbutton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: () {},
            minWidth: 20.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)),
            child: Icon(
              Icons.clear,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class PINNumber extends StatelessWidget {
  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;

  PINNumber(
      {required this.textEditingController, required this.outlineInputBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: outlineInputBorder,
            filled: true,
            fillColor: Colors.blue[100]),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.black,
        ),
      ),
    );
  }
}

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;
  // ignore: use_key_in_widget_constructors
  KeyboardNumber({required this.n, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.blue.withOpacity(0.1)),
      alignment: Alignment.center,
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.0),
        ),
        height: 90.0,
        child: Text(
          "${n}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24 * MediaQuery.of(context).textScaleFactor,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

/*class FingerPrint extends StatefulWidget {
  @override
  State<FingerPrint> createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chechBiometrics();
    _getAvailableiometrices();
  }

  LocalAuthentication auth = LocalAuthentication();
  late bool _canCheckBiometrics;
  late List<BiometricType> _availableBiometrics;
  String autherized = "Not Authorized";
  Future<void> _chechBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      setState(() {
        _canCheckBiometrics = canCheckBiometrics;
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
  }

  Future<void> _getAvailableiometrices() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      setState(() {
        _availableBiometrics = availableBiometrics;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _authenticate() async {
    bool authenticatd = false;
    try {
      authenticatd = await auth.authenticate(
        localizedReason: "Scan your finger to authenticate",
        options: const AuthenticationOptions(useErrorDialogs: true),
      );
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      autherized = authenticatd ? "success" : 'failed';
      print(autherized);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
*/
class FingerPrint {
  static final _auth = LocalAuthentication();
  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      return <BiometricType>[];
    }
  }

  static Future<bool> authenticate() async {
    final bool isBiometricSupported = await _auth.isDeviceSupported();
    if (!isBiometricSupported) return false;
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;
    try {
      return await _auth.authenticate(
          localizedReason: 'Scan your Fingerprint for authenticate',
          options: AuthenticationOptions(
            stickyAuth: true,
            useErrorDialogs: true,
          ));
    } on PlatformException catch (e) {
      return false;
    }
  }
}
