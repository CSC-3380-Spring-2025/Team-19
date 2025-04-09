import 'package:flutter/material.dart';



class LeaderboardSelectionScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(title: Text("View a Leaderboard")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        children: [
          _buildGameTile(context, 'Connections Leaderboard', 'C:UsersjonmaDownloadsTeam-19 3-2-25Team-19liblogosCONNECTIONS.png', () {
            Navigator.pushNamed(context, '/connectionsleaderboard');
          }),
          _buildGameTile(context, 'LetterQuest', 'C:UsersjonmaDownloadsTeam-19 3-2-25Team-19liblogosLETTER QUEST.png', () {
            Navigator.pushNamed(context, '/letterquestleaderboard');
          }),
          _buildGameTile(context, 'Word Ladder', 'C:UsersjonmaDownloadsTeam-19 3-2-25Team-19liblogosWORD LADDER.png', () {
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
