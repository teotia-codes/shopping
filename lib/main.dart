import 'package:flutter/material.dart';
import 'package:shopping/models/grocery_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Groceries',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 0, 193, 241),
          brightness: Brightness.dark,
          surface: Color.fromARGB(255, 255, 181, 9),
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255)   ),
      home:const  GroceryList(),
    );
  }
}