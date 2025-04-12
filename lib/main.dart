import 'package:flutter/material.dart';
import 'package:team_19/home_page.dart';
import 'package:team_19/leaderboard_selector.dart';
import 'game_selector.dart'; 
import 'connections.dart';
import 'letterquest.dart';
import 'wordladder_frontend.dart';
import 'letterquest_leaderboard_page.dart';
import 'wordladder_leaderboard_page.dart';
import 'connections_leaderboard_page.dart';
import 'profile_page.dart';

void main() {
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
        '/gameselection': (context) => GameSelectionScreen(), 
        '/leaderboardselection': (context) => LeaderboardSelectionScreen(),
        '/connections': (context) => ConnectionsGameScreen(),
        '/letterquest': (context) => LetterQuestGame(),
        '/wordladder': (context) => WordLadderGame(),
        '/letterquestleaderboard': (context) => LetterQuestLeaderboard(),
        '/wordladderleaderboard' : (context) => WordLadderLeaderboard(), 
        '/connectionsleaderboard' : (context) => ConnectionsLeaderboard(), 
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
