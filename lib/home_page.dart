import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Import Flutter Animate for animations
import 'alert_screen.dart';
import 'alerts_page.dart';
import 'awareness_page.dart';
import 'feedback_page.dart';
import 'rewards_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(), // Sidebar Drawer
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Default font
        ),
        backgroundColor: Colors.deepPurple, // Custom color for AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                _createRoute(ProfilePage(
                  name: 'John Doe',
                  email: 'john.doe@example.com',
                  phone: '123-456-7890',
                  dob: '01/01/2000',
                  gender: 'Male',
                  imageUrl: 'assets/images/profile_image.jpg', // Correctly referenced image
                )),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome Text with Animation
            Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.5),

            SizedBox(height: 20),

            // Profile Section with Image and Name
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile_image.png'),
            ).animate().scale(duration: 700.ms),
            SizedBox(height: 10),
            Text('John Doe', style: TextStyle(fontSize: 20, color: Colors.white)),

            SizedBox(height: 40),

            // Action Cards (Alerts, Rewards, etc.)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(16),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children:<Widget> [
                  _buildActionCard(context, Icons.notification_important, "Alerts", Colors.redAccent),
                  _buildActionCard(context, Icons.card_giftcard, "Rewards", Colors.orangeAccent),
                  _buildActionCard(context, Icons.volunteer_activism, "Awareness", Colors.greenAccent),
                  _buildActionCard(context, Icons.feedback, "Feedback", Colors.blueAccent),
                ],
              ),
            ),

            // Floating SOS Button with Animation
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context, _createRoute(AlertScreen()));
              },
              label: Text('SOS', style: TextStyle(fontSize: 18)),
              icon: Icon(Icons.warning),
              backgroundColor: Colors.redAccent,
            ).animate().fadeIn(duration :500.ms).scale(),
          ],
        ),
      ),
    );
  }

  // Custom page transition with SlideTransition
  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder:(context, animation, secondaryAnimation) => page,
      transitionsBuilder:(context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0 ,0.0); 
        const end = Offset.zero ;
        final tween = Tween(begin :begin ,end :end );
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position :offsetAnimation ,child :child );
      },
    );
  }

  // Helper method to create action cards
  Widget _buildActionCard(BuildContext context, IconData iconData, String title, Color color) {
    return GestureDetector(
      onTap :() {
        Navigator.push(context ,_createRoute(AlertScreen())); // Navigate to respective pages
      },
      child :Container (
        decoration :BoxDecoration (
          color :color.withOpacity(0.8), 
          borderRadius :BorderRadius.circular(16), 
          boxShadow :[BoxShadow(color :Colors.black26 ,blurRadius :8)]), 
        child :Column (
          mainAxisAlignment :MainAxisAlignment.center ,children:<Widget> [
          Icon(iconData ,size :50,color :Colors.white ), 
          SizedBox(height :10), 
          Text(title ,style :
          TextStyle(fontSize :18,fontWeight :FontWeight.bold,color :
          Colors.white ))]))).animate().fadeIn(duration :700.ms);
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child :ListView (
        padding :EdgeInsets.zero ,
        children:<Widget> [
          DrawerHeader (
            decoration :BoxDecoration(color :Colors.deepPurple ), 
            child :Text('Navigation',style :
              TextStyle(fontSize :24,color :Colors.white)), 
          ).animate().fadeIn(duration :800.ms), 

          _buildDrawerItem(context ,Icons.home ,"Home" ,HomePage()),
          _buildDrawerItem(context ,Icons.notification_important ,"Alerts" ,AlertsPage()),
          _buildDrawerItem(context ,Icons.card_giftcard ,"Rewards" ,RewardsPage()),
          _buildDrawerItem(context ,Icons.volunteer_activism ,"Awareness" ,AwarenessPage()),
          _buildDrawerItem(context ,Icons.feedback ,"Feedback" ,FeedbackPage()),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData iconData, String title, Widget page) {
    return ListTile (
      leading :Icon(iconData ,color :Colors.deepPurpleAccent ), 
      title :Text(title ,style :
      TextStyle(fontSize :18)), 
      onTap :( ) {
        Navigator.pop(context);
        Navigator.pushReplacement(context ,_createRoute(page));
      },
    ).animate().fadeIn(duration :700.ms);
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder (
      pageBuilder :(context ,animation ,secondaryAnimation )=> page ,
      transitionsBuilder :(context ,animation ,secondaryAnimation ,child ) {
        const begin = Offset(1.0 ,0.0); 
        const end = Offset.zero ;
        final tween = Tween (begin :begin ,end :end );
        final offsetAnimation = animation .drive (tween );

        return SlideTransition (position :offsetAnimation ,child :child );
      },
    );
  }
}