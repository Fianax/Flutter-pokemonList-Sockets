import 'package:flutter/material.dart';
import 'package:flutter_proyecto_intermedios_udemy/src/pages/home.dart';

void main()=>runApp(const MyApp());

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home': (_)=>HomePage()
      },
    );
  }
}