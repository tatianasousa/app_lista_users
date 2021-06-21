import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class API {
  static Future getUsers() async {
    return await http.get(Uri.parse("https://jsonplaceholder.typicode.com"));
  }
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;

  User(this.id, this.name, this.username, this.email);

  User.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        username = json['username'],
        email = json['email'];
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Http-Json-ListView',
      home: BuildListView(),
    );
  }
}

class BuildListView extends StatefulWidget {
  @override
  _BuildListViewState createState() => _BuildListViewState();
}

class _BuildListViewState extends State<BuildListView> {
  List<User> users = [];
  _getUsers() {
    API.getUsers().then((response) {
      setState(() {
        Iterable lista = json.decode(response.body);
        users = lista.map((model) => User.fromJson(model)).toList();
      });
    });
  }

  _BuildListViewState() {
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Usuários"),
        ),
        body: listaUsuarios());
  }

  listaUsuarios() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(users[index].name,
              style: TextStyle(fontSize: 20.0, color: Colors.black)),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => DetailPage(users[index])));
          },
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;
  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(user.name),
        ),
        body: userDetails());
  }

  userDetails() {
    return Container(
      padding: new EdgeInsets.all(32.0),
      child: ListTile(
        title: Text(user.email, style: TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text("$user.username"),
        leading: Icon(Icons.email, color: Colors.blue),
      ),
    );
  }
}
