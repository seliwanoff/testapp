import 'package:app/contacts/contact.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'dart:ui';
import 'package:contacts_service/contacts_service.dart';

class Airtime extends StatefulWidget {
  const Airtime({Key? key}) : super(key: key);
  State<Airtime> createState() => _AirtimeState();
}

class _AirtimeState extends State<Airtime> {
  TextEditingController receivercontroller = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int selectedvalue = -1;
  int selectednet = 0;
  Color color = Colors.grey;
  bool getclicked = true;
  String network = '1';
  String plan = '';
  String plan_id = '';
  num price = 0;
  String token = '';
  String usename = '';
  String balance = '';
  String naira = '';
  String type = '1';
  bool error = true;
  String username = '';
  List data = [];
  num mdata = 0;
  num ndata = 0;
  num commision = 0;
  String Usertype = '1';
  String message = '';
  List image = [
    'assets/mtn.png',
    'assets/airtel.png',
    'assets/etisalat.png',
    'assets/glo.jpg'
  ];
  final myurl = Uri.parse(
    dotenv.get('API_URL') + 'api/smeplans?type=data',
  );
  final management = Uri.parse(
    dotenv.get('API_URL') + 'api/getmanagement',
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bool error = true;
    getData(type);
    getManagement();
    getuserDatails();
    getAllContacts();
  }

  getAllContacts() async {
    //  List<Contact> _contacts =
    // (await ContactsService.getContacts(withThumbnails: false));
    setState(() {
      //contacts = _contacts;
    });
  }

  getuserDatails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;

    try {
      Response response = await get(myurl, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + token,
        'Content-Type': 'application/json'
      });
      var jsondata = jsonDecode(response.body);

      setState(() {
        Usertype = jsondata['data']['type'];
        username = jsondata['data']['username'];
      });
      //print(response.body);
    } catch (e) {
      print(e);
    }
  }

  getManagement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;

    try {
      Response response = await get(management, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + token,
        'Content-Type': 'application/json'
      });
      var jsondata = jsonDecode(response.body);

      setState(() {
        mdata = num.parse(jsondata['data']['mairtime']);
        ndata = num.parse(jsondata['data']['nairtime']);
      });
    } catch (e) {
      print(e);
    }
  }

  getData(type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;

    try {
      Response response = await get(myurl, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + token,
        'Content-Type': 'application/json'
      });
      var jsondata = jsonDecode(response.body);
      setState(() {
        data = jsondata['data']['data'][type];
      });
      //print(response.body);
    } catch (e) {
      print(e);
    }
  }

  setData(
    receiver,
    price,
    plan_id,
    network,
    plan,
  ) async {
    if (receiver.toString().isNotEmpty && network.toString().isNotEmpty) {
      setState(() {
        error = false;
      });
    } else {
      setState(() {
        error = true;
      });
    }
    if (Usertype == '1') {
    } else if (Usertype == '2') {
      commision = mdata * price;
    }
    if (network == '1') {
      setState(() {
        network = 'MTN';
      });
    } else if (network == '2') {
      setState(() {
        network = 'Airtel';
      });
    } else if (network == '3') {
      setState(() {
        network = '9mobile';
      });
    } else if (network == '4') {
      setState(() {
        network = 'GLO';
      });
    }
    if (error == false) {
      Map<String, dynamic> _dataList = {
        'network': network,
        'plan': plan + ' ' + network,
        'amount': num.parse(price),
        'type': 2,
        'planid': plan_id,
        'commission': commision,
        'status': 1,
        'name': network,
        'username': username,
        'reciever': receiver
      };

      String _DataEncode = jsonEncode(_dataList);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('dataList', _DataEncode);
      Navigator.pushNamed(context, '/checkout');
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
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Airtime',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w100,
                        fontSize: 13),
                  ),
                  GestureDetector(
                      child: Text(
                    'history',
                    style: TextStyle(
                        color: Colors.blue[700],
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w100,
                        fontSize: 13),
                  ))
                ],
              )
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Enter Amount',
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: 12,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  bottomsheet(context);
                                },
                                child: Text('Select Contact'))
                          ],
                        ),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            controller: receivercontroller,
                            autocorrect: false,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                                labelText: ' Phone Number ',
                                hintText: '08145938104 ',
                                fillColor: Colors.blue[100],
                                filled: true),
                            validator: (value) => value.toString().length < 11
                                ? 'Enter a valid number '
                                : null),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text(
                              'Select a network Perovider',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.w200),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(image.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectednet = index;
                                    network = (index + 1).toString();
                                  });
                                  getData('${index + 1}');
                                },
                                child: Container(
                                  child: Center(
                                    child: ClipOval(
                                      child: SizedBox.fromSize(
                                        size: Size.fromRadius(26),
                                        child: Image(
                                          image: AssetImage('${image[index]}'),
                                          width: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: selectednet == index
                                          ? Colors.blue[500]
                                          : Colors.grey[100],
                                      border: Border.all(
                                        color: selectednet == index
                                            ? Colors.blue
                                            : Colors.grey,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            })),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 0,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Enter Amount',
                                      style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: amountController,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    decoration: InputDecoration(
                                        labelText: ' Enter Amount ',
                                        hintText: '08145938104 ',
                                        fillColor: Colors.blue[100],
                                        filled: true),
                                    validator: (value) =>
                                        value.toString().isEmpty
                                            ? 'Enter amount '
                                            : null),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                          color: Colors.blue[700],
                          minWidth: 100,
                          height: 45,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setData(
                                  receivercontroller.text,
                                  amountController.text,
                                  plan_id,
                                  network,
                                  plan);
                            }
                          },
                          child: Text(
                            'Continue',
                            style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: 14,
                                color: Colors.white),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

void bottomsheet(context) {
  showModalBottomSheet(
      enableDrag: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Contacts(),
          ));
}
