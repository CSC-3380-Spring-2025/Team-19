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
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.deepPurple[50],
      ),
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
    leaderboardData = fetchLeaderboard();
  }

  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    final List<User> users = await DatabaseHelper.fetchAllUsers();
    int dateID = 1; 
    List<LeaderboardEntry> entries = []; 

    for (User user in users) {
      if (user.wordladderTimes.containsKey(dateID)) {
        entries.add(
          LeaderboardEntry(username: user.name, timeTaken: user.wordladderTimes[dateID]!, score: user.wordladderScores[dateID]!),
        );
      }
    }

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

  Color getEntryColor(int index) {
    if (index == 0) return Colors.deepPurple[200]!;
    if (index == 1) return Colors.deepPurple[100]!;
    if (index == 2) return Colors.deepPurple[50]!;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        title: Text("WordLadder Daily Leaderboard"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: FutureBuilder<List<LeaderboardEntry>>(
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
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ListView.separated(
                  itemCount: leaderboard.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey[300], thickness: 1, height: 1),
                  itemBuilder: (context, index) {
                    LeaderboardEntry entry = leaderboard[index];
                    return Container(
                      width: double.infinity,
                      color: getEntryColor(index),
                      child: ListTile(
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
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LeaderboardEntry {
  final String username;
  final int timeTaken;
  final int score;

  LeaderboardEntry({required this.username, required this.timeTaken, required this.score});
}