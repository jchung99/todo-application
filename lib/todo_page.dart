import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';

class TodoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<TodoList> {
  final collection =
      FirebaseFirestore.instance.collection(LogIn.userName + LogIn.password);
  final inputController = TextEditingController();
  var counter = 0;

  @override
  Widget build(BuildContext context) {

    collection.get().then((value) async {
      // Need better fix. Should run immediately after removal of dismissible, not hard coded to run after 200 ms.
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          counter = value.size;
        });
      });
    });
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Todo List: Tap or slide when a task is done',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        body: Center(
          child: Column(children: [
            
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(counter.toString() + " items in list",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Divider(
              thickness: 1,
              color: Colors.black,
            ),

            buildStreamBuilder(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 280,
                  height: 50,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'Add new todo',
                    ),
                    controller: inputController,
                  ),
                ),
                SizedBox(width: 10),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.cyan,
                  child: MaterialButton(
                      onPressed: () => addItem(inputController.text),
                      child: Text("Add Item")),
                ),
              ],
            ),
          ]),
        ));
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> buildStreamBuilder() {
    return StreamBuilder(
      stream: collection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text("Loading");
        return Flexible(
          child: Container(
            height: 530,
            child: ListView.builder(
                itemCount: (snapshot.data as QuerySnapshot).docs.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  var docId = (snapshot.data as QuerySnapshot).docs[index].id;
                  return Dismissible(
                    key: Key(docId),
                    background: Container(color: Colors.red),
                    onDismissed: (both) => _removeItem(docId),
                    child: TextButton(
                      onPressed: () => _removeItem(docId),
                      child: Text(
                        (snapshot.data as QuerySnapshot).docs[index]['val'],
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        );
      },
    );
  }

  addItem(val) async {
    var now = DateTime.now();
    await collection.doc(now.toString()).set({'val': val});
    inputController.clear();
  }

  _removeItem(id) {
    collection.doc(id).delete();
  }
}
