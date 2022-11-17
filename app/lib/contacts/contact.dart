import 'dart:ffi';

import 'package:app/loading.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String receiver = '';
  List<Contact> contacts = [];
  List<Contact> contactFiltered = [];

  TextEditingController searchController = TextEditingController();
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllContact();
    searchController.addListener(() {
      filterContacts();
    });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchterm = searchController.text.toLowerCase();
        String contactName = contact.displayName!.toLowerCase();
        bool nameMatch = contactName.contains(searchterm);
        if (nameMatch == true) {
          return true;
        }
        var phone = contact.phones!.firstWhere(
          (phn) {
            return phn.value!.contains(searchterm);
          },
        );
        return phone != null;
      });
      setState(() {
        contactFiltered = _contacts;
      });
    }
  }

  getAllContact() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      List<Contact> _contacts = (await ContactsService.getContacts()).toList();
      print(_contacts);
      setState(() {
        contacts = _contacts;
        loading = false;
      });
    } else if (status.isDenied) {
      if (await Permission.contacts.request().isGranted) {
        print('permitted');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return loading
        ? Center(child: Loading())
        : SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: isSearching == true
                        ? contactFiltered.length
                        : contacts.length,
                    itemBuilder: (context, index) {
                      Contact contact = isSearching == true
                          ? contactFiltered[index]
                          : contacts[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            receiver = contact.phones!.elementAt(0).value!;
                          });
                        },
                        child: ListTile(
                          title: Text(contact.displayName!),
                          subtitle: Text(contact.phones!.elementAt(0).value!),
                          leading: CircleAvatar(
                              child: Text(
                            contact.initials(),
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
