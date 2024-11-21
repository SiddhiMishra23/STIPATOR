import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    )
      ..repeat(reverse: true); // This makes the animation repeat (blinking effect)
    
    // Animation to change opacity
    _opacityAnimation = Tween(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SOS',
          style: GoogleFonts.righteous(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent, // Matching AppBar with SOS theme
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFCE4EC), // Light Pink
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
              // "Are you in emergency?" Text
              Text(
                'Are you in emergency?',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Blinking Circle Button
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return GestureDetector(
                    onLongPress: () {
                      // Logic to trigger SOS action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('SOS Triggered! Help is on the way.')),
                      );
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent.withOpacity(_opacityAnimation.value),
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
                          'SOS\nPress for 3 seconds',
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
              // Instruction Text
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
