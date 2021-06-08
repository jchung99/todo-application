
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_application/todo_page.dart';
import 'package:to_do_application/main.dart';


//Unit Tests
void  main() async {

  test("sample_test", () {
    LogIn.password = "test_password";


expect(LogIn.password, "test_password");
  }

  );

  test("test username/password change", () {
    final temp = LogIn();
    temp.nextPage("testName", "testPass", null);
    expect(LogIn.password, "testName");
  });
  
  testWidgets("LogIn Page Text Test", (tester) async {
    await tester.pumpWidget(ToDo());
    final welcomeFinder = find.text("Welcome! Please enter your name and password!");
    expect(welcomeFinder, findsOneWidget);
    final nameFinder = find.text("Name");
    final passwordFinder = find.text("Password");
    expect(nameFinder, findsOneWidget);
    expect(passwordFinder, findsOneWidget);

  });
}