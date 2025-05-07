import 'package:flutter/material.dart';
import 'package:team_19/profile_page.dart';

class LeaderboardSelectionScreen extends StatelessWidget {
  final String userName;
  LeaderboardSelectionScreen({required this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        title: const Text(
          "View a Leaderboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                userName,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // 👈 makes it readable on purple
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userName: userName),
              ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "Pick a Leaderboard:",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Leaderboards only reflect scores from the 1st level of each game. The rest are for fun!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepPurple[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGameTile(
                    context,
                    'Scattergories',
                    'assets/images/connections_logo.png',
                    () => Navigator.pushNamed(context, '/connectionsleaderboard'),
                  ),
                  const SizedBox(width: 16),
                  _buildGameTile(
                    context,
                    'LetterQuest',
                    'assets/images/letterquest_logo.png',
                    () => Navigator.pushNamed(context, '/letterquestleaderboard'),
                  ),
                  const SizedBox(width: 16),
                  _buildGameTile(
                    context,
                    'Word Ladder',
                    'assets/images/wordladder_logo.png',
                    () => Navigator.pushNamed(context, '/wordladderleaderboard'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameTile(BuildContext context, String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 180,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
