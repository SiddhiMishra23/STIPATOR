import 'package:flutter/material.dart';
import 'package:stipator_app/home_page.dart';
import 'profile_page.dart'; // Import the profile page

class AlertsPage extends StatelessWidget {
  // Dummy list of alerts with title, status, time, and location
  final List<Map<String, dynamic>> alerts = [
    {
      'title': 'Suspicious Activity',
      'status': false,
      'time': '3:00 PM',
      'location': 'Park Avenue, NY'
    },
    {
      'title': 'Harassment Incident',
      'status': true,
      'time': '10:15 AM',
      'location': 'Main Street, LA'
    },
    {
      'title': 'Public Disturbance',
      'status': false,
      'time': '7:30 PM',
      'location': '5th Avenue, Chicago'
    },
    {
      'title': 'Unsafe Zone Alert',
      'status': true,
      'time': '2:45 PM',
      'location': 'Downtown, SF'
    },
    {
      'title': 'Security Breach',
      'status': true,
      'time': '11:00 AM',
      'location': 'City Mall, NY'
    },
  ];

  AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back navigation to ensure it goes to the home page.
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage()), // Replace with your HomePage widget
          (route) => false, // Removes all routes until HomePage
        );
        return false; // Prevent the default back navigation behavior
      },
      child: Scaffold(
        drawer: Drawer(
          // Example AppDrawer if needed
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Menu'),
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Alerts'),
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                // Navigate to the ProfilePage when the profile button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      name: 'John Doe', // Sample data
                      email:
                          'johndoe@email.com', // Replace with actual user data
                      phone: '123-456-7890', // Replace with actual user data
                      dob: '01-01-1990', // Replace with actual user data
                      gender: 'Male', // Replace with actual user data
                      imageUrl:
                          'https://via.placeholder.com/150', // User's profile image URL
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Card(
                child: ListTile(
                  leading: Icon(
                    alerts[index]['status'] ? Icons.check_circle : Icons.error,
                    color: alerts[index]['status'] ? Colors.green : Colors.red,
                    size: 40,
                  ),
                  title: Text(alerts[index]['title']),
                  subtitle: Text(
                    'Time: ${alerts[index]['time']}\nLocation: ${alerts[index]['location']}',
                  ),
                  onTap: () {
                    // Show alert details with status
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(alerts[index]['title']),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Time: ${alerts[index]['time']}'),
                            Text('Location: ${alerts[index]['location']}'),
                            SizedBox(height: 10),
                            Text(
                              alerts[index]['status']
                                  ? 'Alert has ended.'
                                  : 'Alert is still active.',
                              style: TextStyle(
                                color: alerts[index]['status']
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
