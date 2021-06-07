import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(ToDo());

}

class ToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override

  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<TodoList> {
  final collection = FirebaseFirestore.instance.collection('items');

  @override
  void initState() {
    getData();
    super.initState();
  }
  getData() {
    collection.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        print(5);
      });
    }) ;
  }
  Widget build(BuildContext context) {
    final collection = FirebaseFirestore.instance.collection('test1');
    return Scaffold(

        appBar: AppBar(
          title: Text('Todo List'),
        ),
        body: Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                await collection.add({'name': "hello"});
              },
              child: Text(
                "Add Here"
              )
            ),
            StreamBuilder(
              stream: collection.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Text("Loading");
                return Text((snapshot.data as QuerySnapshot).docs[0]['test2']);
              },)
          ]
        )

        // body: StreamBuilder(
        //   stream: FirebaseFirestore.instance.collection('items').snapshots(),
        //   builder: (context, snapshot) {
        //     if (!snapshot.hasData) return const Text('Loading');
        //     return Text((snapshot.data as QuerySnapshot).docs[0].get('1'));
        //   }
        //   ,
        // )
    );
  }
}



