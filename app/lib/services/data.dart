import 'package:app/contacts/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'dart:ui';
import 'package:app/shared/loading.dart';

class Data extends StatefulWidget {
  const Data({Key? key}) : super(key: key);
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  List colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.blueGrey,
    Colors.indigo,
    Colors.purple,
    Colors.brown,
    Colors.cyan,
    Colors.amberAccent
  ];
  TextEditingController receivercontroller = TextEditingController();
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
  bool loading = true;

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
        mdata = num.parse(jsondata['data']['mdata']);
        ndata = num.parse(jsondata['data']['ndata']);
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
        loading = false;
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
    if (receiver.toString().isNotEmpty &&
        plan.toString().isNotEmpty &&
        network.toString().isNotEmpty) {
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
    if (error == false) {
      Map<String, dynamic> _dataList = {
        'network': network,
        'plan': plan,
        'amount': price,
        'type': 2,
        'planid': plan_id,
        'commission': commision,
        'status': 1,
        'name': plan,
        'username': username,
        'reciever': receiver
      };
      setState(() {
        loading = true;
      });

      String _DataEncode = jsonEncode(_dataList);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('dataList', _DataEncode);
      Navigator.pushNamed(context, '/checkout');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        'Mobile Data',
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
                        child: ClipRRect(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      fillColor: Colors.lightBlue[100],
                                      filled: true),
                                  validator: (value) =>
                                      value.toString().length < 11
                                          ? 'Enter a valid number '
                                          : null),
                              SizedBox(
                                height: 10,
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
                                height: 15,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children:
                                      List.generate(image.length, (index) {
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
                                                image: AssetImage(
                                                    '${image[index]}'),
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    );
                                  })),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Select plans',
                                        style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  GridView.count(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 3,
                                      shrinkWrap: true,
                                      primary: false,
                                      physics: BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics()),
                                      children:
                                          List.generate(data.length, (index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedvalue = index;
                                              price = data[index]['price'];

                                              plan_id =
                                                  data[index]['id'].toString();
                                              plan = data[index]['name']
                                                  .toString();
                                            });
                                          },
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    " ₦ ${data[index]['price']}",
                                                    style: TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15,
                                                      color:
                                                          selectedvalue == index
                                                              ? Colors.white
                                                              : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                    child: Text(
                                                  "30 Days",
                                                  style: TextStyle(
                                                    fontFamily: 'Ubuntu',
                                                    fontSize: 8,
                                                    color:
                                                        selectedvalue == index
                                                            ? Colors.white
                                                            : Colors.white,
                                                  ),
                                                )),
                                                Center(
                                                    child: Text(
                                                  "${data[index]['name'].substring(0, 3)}",
                                                  style: TextStyle(
                                                    fontFamily: 'Ubuntu',
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 10,
                                                    color:
                                                        selectedvalue == index
                                                            ? Colors.white
                                                            : Colors.white,
                                                  ),
                                                )),
                                              ],
                                            ),
                                            width: 60,
                                            padding: EdgeInsets.all(2),
                                            margin:
                                                EdgeInsets.fromLTRB(5, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                color: selectedvalue == index
                                                    ? colors[index][900]
                                                    : colors[index],
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 56, 146, 236)),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        const Radius.circular(
                                                            10))),
                                          ),
                                        );
                                      })),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FlatButton(
                              color: Colors.blue[700],
                              minWidth: 100,
                              height: 45,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setData(receivercontroller.text, price,
                                      plan_id, network, plan);
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
