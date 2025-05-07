import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart';
import 'package:team_19/home_page.dart';
import 'letterquest_leaderboard_page.dart';
import 'wordladder_leaderboard_page.dart';
import 'connections_leaderboard_page.dart';


void main() {
  if (kIsWeb) { //The initialization below is only for non-mobile. If the code inside runs when the website is on a mobile device, it will not work, which is why this check is here. 
    databaseFactory = databaseFactoryFfiWeb;  // Set up database factory for FFI Web
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WordStorm Games',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), //Eventually, this needs to be changed to the home page 
      routes: {
        '/letterquestleaderboard': (context) => LetterQuestLeaderboard(),
        '/wordladderleaderboard' : (context) => WordLadderLeaderboard(), 
        '/connectionsleaderboard' : (context) => ConnectionsLeaderboard(), 
      },
    );
  }
}
