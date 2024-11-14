import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart'; // For custom fonts
import 'home_page.dart'; // Import HomePage here

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)], // Dark gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:<Widget> [
                const SizedBox(height :50),
                Image.asset('assets/stipator_logo-rg.png', height :120, width :120), // Same logo as SignupPage
                const SizedBox(height :20),
                
                // App Name (Styled with custom font)
                Text(
                  "STIPATOR",
                  style: GoogleFonts.righteous( // Aesthetic curvy font from Google Fonts
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                
                const SizedBox(height :10),
                
                // Tagline (Styled with custom font)
                Text(
                  "Empowering Your Safety",
                  style: GoogleFonts.lora( // Aesthetic cursive font for tagline
                    fontSize: 22,
                    color: Colors.grey[300],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                
                const SizedBox(height :30),

                // Log In Title
                const Text("Log In", style:
                  TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                
                const SizedBox(height :20),

                // Email Input Field
                _buildTextField(emailController, "Email", Icons.email_outlined),

                const SizedBox(height :20),

                // Password Input Field
                _buildTextField(passwordController, "Password", Icons.lock_outline, obscureText:true),

                const SizedBox(height :30),

                // Sign In Button (Gradient)
                ElevatedButton(
                  onPressed: () {
                    _signIn(context, emailController.text, passwordController.text); // Sign in logic
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    backgroundColor: Colors.blueAccent, // Same button style as SignupPage
                  ),
                  child: Container(
                    width :double.infinity,
                    alignment :Alignment.center,
                    child : const Text('Sign In', style : TextStyle(fontSize :18, color :Colors.white)),
                  )
                ),

                const SizedBox(height :20),

                // Forgot Password or Sign Up option
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigate back to Signup page
                  },
                  child:
                   const Text("Don't have an account? Sign up", style:
                   TextStyle(color:
                   Colors.white54 )),
                 )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build a custom text field with rounded corners and icon
  Widget _buildTextField(TextEditingController controller, String hintText, IconData iconData, {bool obscureText = false}) {
    return TextField(
      controller : controller,
      decoration : InputDecoration(
        hintText : hintText,
        hintStyle : const TextStyle(color : Colors.grey),
        prefixIcon : Icon(iconData, color : Colors.grey),
        filled:true,
        fillColor : Colors.white.withOpacity(0.1),
        border : OutlineInputBorder(borderRadius : BorderRadius.circular(30), borderSide : BorderSide.none)
      ),
      obscureText : obscureText,
      style : const TextStyle(color : Colors.white),
    );
  }

  // Sign-in with Firebase Authentication
  Future<void> _signIn(BuildContext context,String email,String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email:
      email,password:
      password);
      
      // Navigate to HomePage after successful login
      _navigateToHome(context);
      
    } on FirebaseAuthException catch(e) {
      if(e.code == 'user-not-found') {
        _showErrorDialog(context,"No user found for that email.");
      } else if(e.code == 'wrong-password') {
        _showErrorDialog(context,"Wrong password provided.");
      }
    }
  }

  // Custom navigation function with transition to HomePage
  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder:(context, animation, secondaryAnimation) => const HomePage(), transitionsBuilder:(context, animation, secondaryAnimation, child) {
      final tween = Tween(begin:
         const Offset(1.0,0.0),end:
         Offset.zero);
       final offsetAnimation = animation.drive(tween);
       return SlideTransition(position:
         offsetAnimation,child:
         child);
     }));
   }

   // Show error dialog
   void _showErrorDialog(BuildContext context,String message) {
     showDialog(context:
       context,builder:(context)=>
       AlertDialog(title:
         const Text("Error"),content:
         Text(message),actions:[
           ElevatedButton(onPressed:
             ()=>Navigator.pop(context),child:
             const Text("OK")),
         ]),
     );
   }
}