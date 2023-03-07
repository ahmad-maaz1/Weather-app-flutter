import 'package:flutter/material.dart';
import 'package:timertempapp/Screens/isolatehomescreen.dart';
import 'package:timertempapp/Screens/streamhomescreen.dart';
import 'package:timertempapp/Screens/startscreen.dart';
import 'Screens/homescreen.dart';
import 'Screens/isolatechartscreen.dart';

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      initialRoute: '/start',
      routes: {
        '/home': ((context) => HomeScreen()),
        '/start': (context) => StartScreen(),
        '/isolatehome': (context) => IsolateHomeScreen(),
        '/streamhomescreen': (context) => StreamHomeScreen(),
        //'/IsolateChartScreen': (context) => IsolateChartScreen(),
        //'/chartscreen': (context) => ChartScreen(),
        //'/': (context) => LoadingState(),
        //'/chooselocation': (context) => ChooseCity(),
      },
    ),
  );
}
