import 'package:flutter/material.dart';
import 'app_drawer.dart'; // Ensure this import is correct

class RewardsPage extends StatelessWidget {
  // Dummy list of rewards based on activity
  final List<Map<String, String>> rewards = [
    {
      'title': 'Bronze Responder',
      'date': 'July 15, 2024',
      'description': 'Responded to 5 SOS calls and helped secure safety.',
    },
    {
      'title': 'Silver Guardian',
      'date': 'August 1, 2024',
      'description': 'Ensured safety during 10 potential danger alerts.',
    },
    {
      'title': 'Gold Protector',
      'date': 'September 5, 2024',
      'description': 'Successfully resolved 20 SOS alerts and helped women reach safe locations.',
    },
    {
      'title': 'Platinum Savior',
      'date': 'September 15, 2024',
      'description': 'Assisted in 30 active alerts and secured emergency aid.',
    },
    {
      'title': 'Diamond Hero',
      'date': 'October 2, 2024',
      'description': 'Safeguarded women from harm through quick response in 50 alerts.',
    },
  ];

   RewardsPage({super.key}); // Marking as const

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(), // Use const since AppDrawer is stateless
      appBar: AppBar(
        title: const Text('Rewards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Profile button action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile button pressed')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Card(
              child: ListTile(
                leading: const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 40,
                ),
                title: Text(rewards[index]['title'] ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${rewards[index]['date']}'),
                    const SizedBox(height: 5),
                    Text(rewards[index]['description'] ?? ''),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}