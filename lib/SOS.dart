import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Import for address retrieval
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Blinking effect

    // Animation for opacity change
    _opacityAnimation = Tween(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendSOS() async {
    try {
      // Get user's current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from latitude and longitude
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = "";
      String pincode = "";
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address = "${place.street}, ${place.locality}, ${place.country}";
        pincode = place.postalCode ?? "N/A";
      }

      // Construct the SOS message
      String message = "Emergency! I need help. My current location is:\n"
          "Address: $address\n"
          "Pincode: $pincode\n"
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}\n"
          "Google Maps Link: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

      // Send Email instead of SMS
      await _sendEmail(message);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SOS email sent successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send SOS email: $e')),
      );
    }
  }

  Future<void> _sendEmail(String message) async {
    // Replace with your email and password
    String username = 'siddhimishra122@gmail.com';
    String password = 'jeoe qjbu muvy zvgn'; // Use an App Password for Gmail

    // Define the SMTP server
    final smtpServer = gmail(username, password);

    // Create the email
    final email = Message()
      ..from = Address(username, 'Your Name')
      ..recipients.add('siddhimishra122@gmail.com')
      ..subject = 'Emergency SOS Alert'
      ..text = message;

    try {
      final sendReport = await send(email, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      print('Message not sent. Error: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SOS',
          style: GoogleFonts.righteous(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 243, 228, 233), // Light Pink
              Color(0xFFF8BBD0), // Pink Shade
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Are you in an EMERGENCY?',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return GestureDetector(
                    onLongPress: () async {
                      await _sendSOS();
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            Colors.redAccent.withOpacity(_opacityAnimation.value),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '!SOS!\nPress for 3 seconds',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.righteous(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              Text(
                'KEEP CALM!\nAfter pressing the SOS button, help will arrive shortly.',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
