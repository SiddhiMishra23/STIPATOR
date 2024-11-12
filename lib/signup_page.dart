import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart'; // Import HomePage here

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: Colors.black, // Dark background color
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:<Widget> [
              Column (
                children:<Widget> [
                 const SizedBox(height :60.0),
                 Image.asset('assets/logo.png', height :100,width :100), 
                 const SizedBox(height :20), 
                 ShaderMask (
                   shaderCallback :(bounds )=> LinearGradient (
                   colors:[ Colors.purple ,Colors.blueAccent ], begin :Alignment.topLeft ,end :
                   Alignment.bottomRight ).createShader(Rect.fromLTWH(0,0,bounds.width,bounds.height)), blendMode :
                   BlendMode.srcIn ,child :
                   const Text("STIPATOR",style :
                   TextStyle(fontSize :40,fontWeight :
                   FontWeight.bold,color :
                   Colors.white ))), 
                 const SizedBox(height:10),
                 ShaderMask (
                   shaderCallback :(bounds )=> LinearGradient (
                   colors:[ Colors.orangeAccent ,Colors.yellow ], begin :
                   Alignment.topLeft ,end :
                   Alignment.bottomRight ).createShader(Rect.fromLTWH(0,0,bounds.width,bounds.height)), blendMode :
                   BlendMode.srcIn ,child :
                   const Text("Empowering Your Financial Future",style :
                   TextStyle(fontSize:20,fontWeight :FontWeight.w600,color :Colors.white ))), 
               ],
             ),

             Column(children:<Widget> [
               const SizedBox(height:20), 
               const Text("Sign Up",style :
               TextStyle(fontSize:30,fontWeight :FontWeight.bold,color :Colors.white )),
               const SizedBox(height:20), 

               // Email Input Field 
               TextField(controller:
               emailController ,decoration:
               InputDecoration(hintText :"Email",hintStyle :
               const TextStyle(color:
               Colors.white54 ),border:
               OutlineInputBorder(borderRadius:
               BorderRadius.circular(18),borderSide:
               BorderSide.none ),fillColor:
               Colors.purple.withOpacity(0.1),filled:true,prefixIcon:
               const Icon(Icons.email,color:
               Colors.white)),style:
               const TextStyle(color:
               Colors.white )),
               
               const SizedBox(height:20),

              // Password Input Field 
              TextField(controller:
              passwordController ,decoration:
              InputDecoration(hintText :"Password",hintStyle :
              const TextStyle(color:
              Colors.white54 ),border:
              OutlineInputBorder(borderRadius:
              BorderRadius.circular(18),borderSide:
              BorderSide.none ),fillColor:
              Colors.purple.withOpacity(0.1),filled:true,prefixIcon:
              const Icon(Icons.lock_outline,color:
              Colors.white)),obscureText:true,style:
              const TextStyle(color:
              Colors.white )),
              
              const SizedBox(height:20),

              // Confirm Password Input Field 
              TextField(controller:
              confirmPasswordController ,decoration:
              InputDecoration(hintText :"Confirm Password",hintStyle :
              const TextStyle(color:
              Colors.white54 ),border:
              OutlineInputBorder(borderRadius:
              BorderRadius.circular(18),borderSide:
              BorderSide.none ),fillColor:
              Colors.purple.withOpacity(0.1),filled:true,prefixIcon:
              const Icon(Icons.lock_outline,color:
              Colors.white)),obscureText:true,style:
              const TextStyle(color:
              Colors.white )),
              
              const SizedBox(height:30),

              // Sign Up Button
              ElevatedButton(
                onPressed: () {
                  _signUp(context, emailController.text, passwordController.text, confirmPasswordController.text); // Sign up logic
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
              ),
             ]),
           ],
         )
       )
     )
   );
 }

 // Sign-up with Firebase Authentication
 Future<void> _signUp(BuildContext context, String email, String password, String confirmPassword) async {
   if (password != confirmPassword) {
     _showErrorDialog(context, "Passwords do not match.");
     return;
   }

   try {
     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
       email: email,
       password: password,
     );
     // Navigate to HomePage after successful signup
     _navigateToHome(context);
   } on FirebaseAuthException catch (e) {
     if (e.code == 'weak-password') {
       _showErrorDialog(context, "The password provided is too weak.");
     } else if (e.code == 'email-already-in-use') {
       _showErrorDialog(context, "The account already exists for that email.");
     }
   } catch (e) {
     _showErrorDialog(context, "An error occurred. Please try again.");
   }
 }

 // Custom navigation function with transition
 void _navigateToHome(BuildContext context) {
   Navigator.pushReplacement(
     context,
     PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
       transitionsBuilder: (context, animation, secondaryAnimation, child) {
         const begin = Offset(1.0, 0.0); // Slide from right
         const end = Offset.zero;
         final tween = Tween(begin: begin, end: end);
         final offsetAnimation = animation.drive(tween);

         return SlideTransition(
           position: offsetAnimation,
           child: child,
         );
       },
     ),
   );
 }

 // Show error dialog
 void _showErrorDialog(BuildContext context, String message) {
   showDialog(
     context: context,
     builder: (context) => AlertDialog(
       title: Text("Error"),
       content: Text(message),
       actions: [
         ElevatedButton(
           onPressed: () => Navigator.pop(context),
           child: Text("OK"),
         ),
       ],
     ),
   );
 }
}