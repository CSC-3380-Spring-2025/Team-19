import 'package:flutter/material.dart';
import 'dart:async';
import 'package:team_19/db/databasehelper.dart';
import 'package:team_19/models/user_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LetterQuest Leaderboard",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.deepPurple[50],
      ),
      home: LetterQuestLeaderboard(),
    );
  }
}

class LetterQuestLeaderboard extends StatefulWidget {
  @override
  _LetterQuestLeaderboardPageState createState() => _LetterQuestLeaderboardPageState();
}

class _LetterQuestLeaderboardPageState extends State<LetterQuestLeaderboard> {
  late Future<List<LeaderboardEntry>> leaderboardData;

  @override
  void initState() {
    super.initState();
    leaderboardData = fetchLeaderboard();
  }

  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    final List<User> users = await DatabaseHelper.fetchAllUsers();
    int dateID = 1; 
    List<LeaderboardEntry> entries = []; 

    for (User user in users) {
      if (user.letterquestTimes.containsKey(dateID)) {
        entries.add(
          LeaderboardEntry(username: user.name, timeTaken: user.letterquestTimes[dateID]!),
        );
      }
    }

    entries.sort((a, b) => a.timeTaken.compareTo(b.timeTaken));

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        title: Text("LetterQuest Daily Leaderboard"),
      ),
      body: FutureBuilder<List<LeaderboardEntry>>(
        future: leaderboardData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading leaderboard", style: TextStyle(fontSize: 20)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available", style: TextStyle(fontSize: 20)));
          }

          List<LeaderboardEntry> leaderboard = snapshot.data!;
          return ListView.builder(
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              LeaderboardEntry entry = leaderboard[index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                leading: CircleAvatar(
                  radius: 25,
                  child: Text("${index + 1}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                title: Text(
                  entry.username,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                trailing: Text(
                  "${entry.timeTaken}s",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class LeaderboardEntry {
  final String username;
  final int timeTaken;

  LeaderboardEntry({required this.username, required this.timeTaken});
}
