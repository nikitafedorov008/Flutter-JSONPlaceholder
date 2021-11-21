import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testovoye/models/user_model.dart';
import 'package:testovoye/api/fetch_data.dart';
import 'package:testovoye/widgets/flexible_space_background.dart';
import 'package:testovoye/widgets/user_item.dart';
import 'package:http/http.dart' as http;


class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {

  userDataStorage() async {
    var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    String userDatabase;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(response.statusCode == 200) {
      userDatabase = response.body;
      prefs.setString('users', userDatabase);
    } else {
      prefs.getString('users');
    }
    setState(() {});
    return prefs;
  }

  Future<List<UserModel>> fetchUsers() async {
    userDataStorage();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return List<UserModel>.from(
      json.decode(prefs.getString('users').toString()).map((x) => UserModel.fromJson(x)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        elevation: 24,
        flexibleSpace: flexibleSpaceBackground(context),
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                //physics: ClampingScrollPhysics(),
                children: [
                  for (var item in snapshot.requireData)
                    userItem(context, item),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
