import 'package:flutter/material.dart';
import 'package:team_19/connections.dart';
import 'package:team_19/letterquest.dart';
import 'package:team_19/wordladder_frontend.dart';

class GameSelectionScreen extends StatelessWidget {
  final String userName;
  GameSelectionScreen({required this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Select a Game",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Choose Your Challenge:",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[800],
                ),
              ),
            ),
            const SizedBox(height: 8), // Add spacing between the title and the new text
            Text(
              "Timer will start upon clicking a game",
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGameTile(
                    context,
                    'Connections',
                    'assets/images/connections_logo.png',
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectionsGameScreen(userName: userName))),
                  ),
                  const SizedBox(width: 16),
                  _buildGameTile(
                    context,
                    'LetterQuest',
                    'assets/images/letterquest_logo.png',
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => LetterQuestGame(userName: userName))),
                  ),
                  const SizedBox(width: 16),
                  _buildGameTile(
                    context,
                    'Word Ladder',
                    'assets/images/wordladder_logo.png',
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => WordLadderGame(userName: userName))),
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
