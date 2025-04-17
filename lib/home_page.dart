import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WordStorm", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            }
          )
        ]
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Image.asset(
              'assets/images/wordstorm.png',
              height: 500,
            ),
            ElevatedButton(
              onPressed: () {
                 Navigator.pushNamed(context, '/gameselection');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text("Play", style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20), //Spacing between the play and leaderboard buttons
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/leaderboardselection');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text("Daily Leaderboards", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
