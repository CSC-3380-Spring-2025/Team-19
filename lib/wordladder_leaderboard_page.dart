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
      title: "WordLadder Leaderboard",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WordLadderLeaderboard(),
    );
  }
}

class WordLadderLeaderboard extends StatefulWidget {
  @override
  _WordLadderLeaderboardPageState createState() => _WordLadderLeaderboardPageState();
}

class _WordLadderLeaderboardPageState extends State<WordLadderLeaderboard> {
  late Future<List<LeaderboardEntry>> leaderboardData;

  @override
  void initState() {
    super.initState();
    leaderboardData = fetchLeaderboard(); // Fetch data when the page loads to keep it up to date when users open the page. 
  }

   Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    final List<User> users = await DatabaseHelper.fetchAllUsers();
    int dateID = 1; //Used in order to ensure the leaderboard loads only that day's entries. It's just a placeholder right now. 
    //Potentially make it the actual date? Will need to set up database more for it. 
    List<LeaderboardEntry> entries = []; 

    for (User user in users) {
      if (user.wordladderScores.containsKey(dateID) && user.wordladderTimes.containsKey(dateID)) {
        entries.add(
          LeaderboardEntry(username: user.name, score: user.wordladderScores[dateID]!, timeTaken: user.wordladderTimes[dateID]!),
        );
      }
    }

/*
    List<LeaderboardEntry> entries = [//Used for testing the page without database entries. Placements were decided randomly using wheelofnames.com 
    LeaderboardEntry(username: "Jonnathan M.", score: 100, timeTaken: 90),
    LeaderboardEntry(username: "Jonnathan B.", score: 80, timeTaken: 120),
    LeaderboardEntry(username: "Beau", score: 75, timeTaken: 123),
    LeaderboardEntry(username: "Bryce", score: 1, timeTaken: 999),
    LeaderboardEntry(username: "Skylur", score: 50, timeTaken: 110),
    LeaderboardEntry(username: "Tie Breaker A", score: 80, timeTaken: 100),
    LeaderboardEntry(username: "Tie Breaker B", score: 80, timeTaken: 95),
    ];
*/

    // Sort by score descending, then by time ascending
    entries.sort((a, b) {
      if (b.score != a.score) {
        return b.score.compareTo(a.score); // Higher score first
      } else {
        return a.timeTaken.compareTo(b.timeTaken); // Faster time wins tie
      }
    });

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Word Ladder Daily Leaderboard", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
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
                subtitle: Text(
                  "Time: ${entry.timeTaken}s",
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                trailing: Text(
                  "Score: ${entry.score}",
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

// Model class for leaderboard entry
class LeaderboardEntry {
  final String username;
  final int score;
  final int timeTaken;

  LeaderboardEntry({required this.username, required this.score, required this.timeTaken});
}
