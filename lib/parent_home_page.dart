import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'home_page.dart'; // Import the correct profile page

class ParentHomePage extends StatelessWidget {
  const ParentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Home"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        // Gradient background mix of black and grey
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black, // Black color at the top
              Colors.grey,  // Grey color at the bottom
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Align the text at the top and center horizontally
              Align(
                alignment: Alignment.topCenter,  // Align at the top center
                child: Text(
                  "Empower Your Child's Safety, Stay Informed, Stay Connected",
                  style: GoogleFonts.righteous(  // Stylish font (Righteous)
                    fontSize: 28,  // Adjust the font size
                    color: Colors.white,  // White color
                    fontWeight: FontWeight.bold,  // Bold text
                  ),
                  textAlign: TextAlign.center,  // Center horizontally
                ),
              ),
              const SizedBox(height: 30),  // Space between text and button

              // View Profile Button - Square and styled
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Profile Page when the button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),  // Update to navigate to the correct page
                  );
                },
                child: const Text(
                  "View Profile",
                  style: TextStyle(
                    fontSize: 20,  // Bigger font size
                    fontWeight: FontWeight.bold,  // Bold text for emphasis
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(30),  // Increase padding for bigger button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),  // Rounded corners
                  ),
                  backgroundColor: Colors.blue,  // Blue background
                  foregroundColor: Colors.white,  // White text color
                  elevation: 5,  // Shadow for depth
                  side: BorderSide(color: Colors.blueAccent, width: 2),  // Border color and width
                ),
              ),

              const SizedBox(height: 20),  // Space between button and the bottom
            ],
          ),
        ),
      ),
    );
  }
}
