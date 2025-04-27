import 'package:flutter/material.dart';
import 'package:team_19/db/databasehelper.dart';
import 'package:team_19/game_selector.dart';
import 'package:team_19/models/user_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;

  @override
  void initState() {
    super.initState();
    
    // Delay the dialog until after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNameDialog();
    });
  }

   // Function to show dialog to enter name
  void _showNameDialog() {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing without input
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Your Name'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: 'Your name here'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                String enteredName = nameController.text.trim();
                User? existingUser = await DatabaseHelper.fetchUserByName(enteredName);
                if (existingUser == null) {
                  User newUser = User(
                    name: enteredName,
                    connectionsScores: {},
                    connectionsTimes: {},
                    letterquestScores: {},
                    letterquestTimes: {},
                    wordladderScores: {},
                    wordladderTimes: {},
                  );
                  await DatabaseHelper.addUser(newUser);
                }
                setState(() {
                  userName = enteredName;
                });
                navigator.pop();
                },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
                 Navigator.push(context, MaterialPageRoute(builder: (context) => GameSelectionScreen(userName: userName!),
              ),
            );
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
