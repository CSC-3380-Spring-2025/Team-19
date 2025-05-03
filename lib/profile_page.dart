import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  ProfilePage({required this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                SizedBox(height: 16),
                Text(
                  'Welcome,',
                  style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                ),
                Text(
                  userName,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: Icon(Icons.logout),
                  label: Text('Sign Out'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                   //TODO: Implement functionality to re-call Username Pop Up
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
