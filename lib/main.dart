import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: ToDo(),
    ),
  );
}

class ToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          ),
      home: new LogIn(),
    );
  }
}

class LogIn extends ConsumerWidget {
  static var userName = "";
  static var password = "";
  final passwordProvider = Provider((ref) => password);
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final passwordString = watch(passwordProvider);
    return Center(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Welcome! Please enter your name and password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30
                  ),
                ),
                SizedBox(height: 100),
                Padding(
                  padding:EdgeInsets.all(10),
                  child: TextField(
                    obscureText: false,
                    style: TextStyle(fontSize: 20),
                    controller: userNameController,
                    decoration: InputDecoration(
                      hintText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    obscureText: true,
                    style: TextStyle(fontSize: 20),
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 10),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.cyan,
                  child: MaterialButton(
                      onPressed: () => nextPage(userNameController.text, passwordController.text, context) ,
                    child: Text(
                      "Login",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  nextPage(name, pass, context) {
    userName = name;
    password = pass;
    Navigator.of(context).push(
      new PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => TodoList(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
        child: child);
      }),
    );
  }
}

