import 'package:flutter/material.dart';
import 'package:todolist/pages/add.dart';
import 'package:todolist/pages/update_todolist.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  _TodolistState createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  List<dynamic> todolistitems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodolist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const AddPage()))
              .then((value) {
            setState(() {
              getTodolist();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  getTodolist();
                });
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ))
        ],
        title: const Text('ALL Todolist'),
      ),
      body: todolistCreate(),
    );
  }

  Widget todolistCreate() {
    return ListView.builder(
        itemCount: todolistitems.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            title: Text("${todolistitems[index]['title']}"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdatePage(
                          todolistitems[index]['id'],
                          todolistitems[index]['title'],
                          todolistitems[index]['detail']))).then((value) {
                setState(() {
                  print(value);
                  if (value == 'delete') {
                    const snackBar = SnackBar(
                      content: Text('ลบรายการเรียบร้อยแล้ว'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  getTodolist();
                });
              });
            },
          ));
        });
  }

  Future<void> getTodolist() async {
    List alltodo = [];
    // var url = Uri.https('ที่อยู่เว็บไซค์rw1968', '/api/post-todolist');
    var url = Uri.http('172.31.15.171:8000', '/api/all-todolist');
    var response = await http.get(url);
    var result = utf8.decode(response.bodyBytes);
    // print(result);
    setState(() {
      todolistitems = jsonDecode(result);
    });
  }
}
