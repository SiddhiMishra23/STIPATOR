import 'package:flutter/material.dart';
import 'home_page.dart'; // Import HomePage here

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: Colors.black, // Same dark background color as SignupPage
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:<Widget> [
              Column (
                children:<Widget> [
                 const SizedBox(height :60.0),
                 // Display logo image (Ensure you have an image in assets)
                 Image.asset('assets/1.png', height :100,width :100), 
                 const SizedBox(height :20), 

                 // Gradient Text for STIPATOR
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

                 // Tagline with Gradient Effect
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

               const Text("Log in",style :
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
              
              const SizedBox(height:30),

              // Sign In Button
              ElevatedButton(
                onPressed: () {
                  _navigateToHome(context); // Navigate with transition
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text('Sign In', style: TextStyle(fontSize: 18)),
              ),
             ]),
           ],
         )
       )
     )
   );
 }

 // Custom navigation function with transition
 void _navigateToHome(BuildContext context) {
   Navigator.pushReplacement(
     context,
     PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
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
}