import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For custom fonts
import 'home_page.dart'; // Import your pages
import 'alerts_page.dart';
import 'rewards_page.dart';
import 'awareness_page.dart';
import 'feedback_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepPurple),
            child: Text(
              'Navigation',
              style: GoogleFonts.righteous(fontSize: 24, color: Colors.white),
            ),
          ),
          _buildDrawerItem(context, Icons.home, "Home", const HomePage()),
          _buildDrawerItem(context, Icons.notification_important, "Alerts", AlertsPage()),
          _buildDrawerItem(context, Icons.card_giftcard, "Rewards", RewardsPage()),
          _buildDrawerItem(context, Icons.volunteer_activism, "Awareness", AwarenessPage()),
          _buildDrawerItem(context, Icons.feedback, "Feedback", const FeedbackPage()),
        ],
      ),
    );
  }

  // Helper method to create drawer items
  Widget _buildDrawerItem(BuildContext context, IconData iconData, String title, Widget page) {
    return ListTile(
      leading: Icon(iconData, color: Colors.deepPurpleAccent),
      title: Text(title, style: GoogleFonts.lato(fontSize: 18)),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => page), // Navigate to the selected page
        );
      },
    );
  }
}