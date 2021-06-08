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
  final inputController = TextEditingController();

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
    final collection = FirebaseFirestore.instance.collection('items');

    return Scaffold(
        appBar: AppBar(
          title: Text('Todo List'),
        ),
        body: Column(

          children: [
            StreamBuilder(
              stream: collection.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Text("Loading");
                return Flexible(
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    height: 295.0,
                    width: 333.0,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: (snapshot.data as QuerySnapshot).docs.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return TextButton(
                              onPressed: () => _removeItem((snapshot.data as QuerySnapshot).docs[index].id),
                              child: Text((snapshot.data as QuerySnapshot).docs[index]['val']));
                        }
                    ),
                  ),
                );
              },)
          ,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Add new todo'
                    ),
                    controller: inputController,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await collection.add({'val': inputController.text});
                  },
                  child: Text(
                      "Add Here"
                  )
              )],
            ),
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


  _removeItem(id) {
    collection.doc(id).delete();
  }
}



