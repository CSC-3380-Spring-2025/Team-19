import 'package:flutter/material.dart';



class LeaderboardSelectionScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text("View a Leaderboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            }
          )
        ]
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        children: [
          _buildGameTile(context, 'Connections Leaderboard', 'C:\Users\jonma\Downloads\Team-19 3-2-25\Team-19\lib\logos\CONNECTIONS.png', () {
            Navigator.pushNamed(context, '/connectionsleaderboard');
          }),
          _buildGameTile(context, 'LetterQuest', 'C:\Users\jonma\Downloads\Team-19 3-2-25\Team-19\lib\logos\LETTER QUEST.png', () {
            Navigator.pushNamed(context, '/letterquestleaderboard');
          }),
          _buildGameTile(context, 'Word Ladder', 'C:\Users\jonma\Downloads\Team-19 3-2-25\Team-19\lib\logos\WORD LADDER.png', () {
            Navigator.pushNamed(context, '/wordladderleaderboard');
          }),
        ],
      ),
    );
  }

  Widget _buildGameTile(BuildContext context, String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 80, height: 80), // Ensure these assets exist
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
