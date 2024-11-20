import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // For animations
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth to get user info
import 'package:google_fonts/google_fonts.dart'; // For custom fonts
import 'profile_page.dart';
import 'LoginPage.dart';
import 'app_drawer.dart';
import 'alert_screen.dart';
import 'alerts_page.dart';
import 'awareness_page.dart';//12
import 'feedback_page.dart';
import 'rewards_page.dart';
import 'map_screen.dart'; // Import your MapScreen here
import 'package:geolocator/geolocator.dart'; // For geolocation services
import 'package:geocoding/geocoding.dart'; // For reverse geocoding (address from coordinates)
import 'profile_page.dart';
import 'customcarouel.dart'; // Assuming this is your custom image slider

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
    _getCurrentLocation(); // Fetch location when the page loads
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled. Please enable them in settings.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    setState(() {
      _currentPosition = position;
      _getAddressFromLatLng(); // Fetch address from coordinates
    });
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
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
          style: GoogleFonts.righteous(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
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
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome Back!',
              style: GoogleFonts.lobster(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ).animate().fadeIn(duration: Duration(milliseconds: 800)).slideY(begin: -0.5),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage(user?.photoURL ?? "assets/images/profile_image.png"),
            ).animate().scale(duration: Duration(milliseconds: 700)),
            const SizedBox(height: 10),
            Text(user?.displayName ?? "No Name", style: GoogleFonts.lato(fontSize: 20, color: Colors.white)),
            Text(user?.email ?? "No Email", style: GoogleFonts.lato(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 10),
            if (_currentPosition != null)
              Text("Location:\nLAT ${_currentPosition!.latitude}, LNG ${_currentPosition!.longitude}",
                  style: GoogleFonts.lato(fontSize: 16, color: Colors.white70)),
            if (_currentAddress != null)
              Text("Address:\n$_currentAddress", style: GoogleFonts.lato(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 40),
            Expanded(
              child:
                  GridView.count(crossAxisCount :2,padding :const EdgeInsets.all(16),crossAxisSpacing :16,mainAxisSpacing :16, children:<Widget> [
                      _buildActionCard(context ,Icons.notification_important ,"Alerts" ,Colors.redAccent),
                      _buildActionCard(context ,Icons.card_giftcard ,"Rewards" ,Colors.orangeAccent),
                      _buildActionCard(context ,Icons.volunteer_activism ,"Awareness" ,Colors.greenAccent),
                      _buildActionCard(context ,Icons.feedback ,"Feedback" ,Colors.blueAccent)
                    ] )
                ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OpenStreetMapExample(
                      locationName: _currentPosition != null 
            ? 'LAT:${_currentPosition!.latitude}, LNG:${_currentPosition!.longitude}'
            : 'Unknown Location',  // Corrected fallback value
        ),
      ),
    );
  },
  icon: Icon(Icons.map),
  label: Text("Show My Location"),
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 241, 241, 244),
  ),
),
            FloatingActionButton.extended(onPressed :( ) {Navigator.push(context ,MaterialPageRoute(builder :(context )=> AlertScreen()));},label :const Text('SOS',style :TextStyle(fontSize :18)),icon :const Icon(Icons.warning),backgroundColor :Colors.redAccent).animate().fadeIn(duration :Duration(milliseconds :500)).scale()
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, IconData iconData, String title, Color color) {
    return GestureDetector(
      onTap:
          () { /* Navigate to respective pages */ },
      child:
          Container(decoration :BoxDecoration(color :color.withOpacity(0.8),borderRadius :BorderRadius.circular(16),boxShadow :[const BoxShadow(color :Colors.black26,blurRadius :8)]),child :Column(mainAxisAlignment :MainAxisAlignment.center,children:<Widget>[Icon(iconData,size :50,color :Colors.white),const SizedBox(height :10),Text(title ,style :GoogleFonts.raleway(fontSize :18,fontWeight :FontWeight.bold,color :Colors.white))]))).animate().fadeIn(duration :Duration(milliseconds :700));
}}