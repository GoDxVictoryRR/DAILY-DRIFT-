import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:untitled1/login.dart';
import 'Login.dart'; // Make sure this is your login screen file

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: ProfilePage(
        isDarkMode: isDarkMode,
        onThemeToggle: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeToggle;

  const ProfilePage({
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    String displayName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : "No Name";
    String email = user?.email ?? "No Email";

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 50),
          ),
          SizedBox(height: 10),
          Text(
            displayName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            email,
            style: TextStyle(color: Colors.grey[400]),
          ),
          SizedBox(height: 20),
          Divider(),

          ListTile(
            leading: Icon(Icons.person_outline, color: Colors.white),
            title: Text("My Profile", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: Colors.white),
            title: Text("About Us", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          SwitchListTile(
            secondary: Icon(Icons.dark_mode, color: Colors.white),
            title: Text("Dark Mode", style: TextStyle(color: Colors.white)),
            value: isDarkMode,
            onChanged: onThemeToggle,
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text("Log Out", style: TextStyle(color: Colors.white)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Loggin()), // <-- rename to match your login page
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
