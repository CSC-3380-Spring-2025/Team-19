import 'package:flutter/material.dart';
import 'dart:async';

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

  // Simulated function to fetch leaderboard data. Will need changing once actual Database is set up. 
  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate API delay (time taken for the information from the Database to be sent for the page)

    return [ //Used for testing the page. Will keep in for now until the Database is set up to pull entries from.
    // Placements were decided randomly using wheelofnames.com 
      LeaderboardEntry(username: "Jonnathan M.", score: 100, timeTaken: 90),
      LeaderboardEntry(username: "Jonnathan B.", score: 80, timeTaken: 120),
      LeaderboardEntry(username: "Beau", score: 75, timeTaken: 123),
      LeaderboardEntry(username: "Bryce", score: 1, timeTaken: 10000000000000000),
      LeaderboardEntry(username: "Skylur", score: 50, timeTaken: 110),
    ]..sort((a, b) => b.score.compareTo(a.score));
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
