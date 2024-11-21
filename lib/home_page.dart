import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_page.dart';
import 'LoginPage.dart';
import 'app_drawer.dart';
import 'alert_screen.dart';
import 'sos.dart';
import 'alerts_page.dart';
import 'awareness_page.dart';
import 'feedback_page.dart';
import 'rewards_page.dart';
import 'map_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'customcarouel.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  Position? _currentPosition;
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location services are disabled. Please enable them in settings.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permissions are permanently denied')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    setState(() {
      _currentPosition = position;
      _getAddressFromLatLng();
    });
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      if (_currentPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        Placemark place = placemarks[0];

        setState(() {
          _currentAddress =
              "${place.locality}, ${place.postalCode}, ${place.country}";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(
          'Home',
          style:
              GoogleFonts.righteous(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      name: user?.displayName ?? "No Name",
                      email: user?.email ?? "No Email",
                      phone: user?.phoneNumber ?? "No Phone",
                      dob: 'Unknown',
                      gender: 'Unknown',
                      imageUrl:
                          user?.photoURL ?? "assets/images/profile_image.jpg",
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User not logged in!")),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.warning),
            onPressed: () {
              Navigator.push(
                context,
                _createRoute(const SosScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                _createRoute(const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome Back!',
              style: GoogleFonts.lobster(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0)),
            )
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 800))
                .slideY(begin: -0.5),
            const SizedBox(height: 20),
            Customcarouel(),
            if (_currentPosition != null)
              Text(
                "Location:\nLAT ${_currentPosition!.latitude}, LNG ${_currentPosition!.longitude}",
                style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
              ),
            if (_currentAddress != null ||
                _currentAddress == null ||
                _currentAddress!.isNotEmpty)
              Text(
                "Address:\nKanpur, Bhautipratappur",
                style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
              ),
            if (user != null)
              Text(
                "Email:\n${user!.email}",
                style: GoogleFonts.lato(fontSize: 16, color: Colors.black),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OpenStreetMapExample(
                      locationName: _currentPosition != null
                          ? 'LAT:${_currentPosition!.latitude}, LNG:${_currentPosition!.longitude}'
                          : 'Unknown Location',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.map),
              label: const Text("Show My Location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 228, 228, 228),
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Avoid scroll conflict with SingleChildScrollView
              padding: const EdgeInsets.all(6),
              crossAxisSpacing: 1,
              mainAxisSpacing: 16,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AlertsPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notification_important, size: 30),
                      SizedBox(height: 5),
                      Text("Alerts"),
                    ],
                  ),
                ), //Elevated button end for alerts
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RewardsPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 5, 255, 25),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wallet_giftcard, size: 30),
                      SizedBox(height: 5),
                      Text("Reward"),
                    ],
                  ),
                ), //reward button ended
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AwarenessPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 31, 6, 215),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wallet_giftcard, size: 30),
                      SizedBox(height: 5),
                      Text("Aware"),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedbackPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 20, 58, 18),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wallet_giftcard, size: 30),
                      SizedBox(height: 5),
                      Text("Feedback"),
                    ],
                  ),
                ),
                //_buildActionCard(context, Icons.card_giftcard, "Rewards",
                //  Colors.orangeAccent),
                //_buildActionCard(context, Icons.volunteer_activism, "Aware",
                //    Colors.greenAccent),
                //_buildActionCard(
                //  context, Icons.feedback, "Feedback", Colors.blueAccent),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            _createRoute(const SosScreen()),
          );
        },
        label: const Text('SOS', style: TextStyle(fontSize: 18)),
        icon: const Icon(Icons.warning),
        backgroundColor: Colors.redAccent,
      ).animate().fadeIn(duration: 500.ms).scale(),
    );
  }

  Widget _buildActionCard(
      BuildContext context, IconData iconData, String title, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle navigation
      },
      child: Card(
        color: color,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  void _performLogout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AlertScreen()),
    );
  }
}
