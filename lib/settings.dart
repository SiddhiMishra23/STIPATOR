import 'package:flutter/material.dart';
import 'package:stipator_app/loginPage.dart';
import 'package:stipator_app/signup_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Edit Profile"),
            onTap: () {
              // Navigate to Edit Profile Screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change Password"),
            onTap: () {
              // Navigate to Change Password Screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            onTap: () {
              // Open Notification Settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text("Theme"),
            onTap: () {
              // Open Theme Settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            onTap: () {
              // Open Language Settings
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About App"),
            onTap: () {
              // Show About Dialog
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_support),
            title: const Text("Support"),
            onTap: () {
              // Open Support Screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              // Perform Logout (Clear session, tokens, etc.)
              _performLogout(context);
            },
          )
        ],
      ),
    );
  }

  void _performLogout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const LoginPage()), // Replace LoginPage with your actual login widget
    );
  }
}
