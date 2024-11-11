import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'LoginPage.dart'; 
import 'home_page.dart';

// Define HomePage widget (destination after signup)
class HomePage extends StatelessWidget {
  final CarouselSliderController _controller = CarouselSliderController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(child: Text('Welcome to Home Page', style: TextStyle(fontSize: 24))),
    );
  }
}

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    // List of images for the carousel
    final List<String> imageList = [
      'assets/1.jpg',
      'assets/2.jpg',
      'assets/3.jpg',
      'assets/4.jpg',
      'assets/5.jpg',
    ];

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
            children: <Widget>[
              // Image Carousel Slider
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  aspectRatio: 16 / 9,
                  initialPage: 0,
                ),
                items: imageList.map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Centered logo and gradient text
              Column(
                children: <Widget>[
                  const SizedBox(height: 60.0),
                  // Logo image (Ensure you have an image in assets)
                  Image.asset(
                    'assets/logo.png', // Replace with your logo path
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 20),
                  // Gradient Text for STIPATOR
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.purple, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    blendMode: BlendMode.srcIn,
                    child: const Text(
                      "STIPATOR",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // This will be overridden by ShaderMask
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Styled Tagline with Gradient Effect
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.orangeAccent, Colors.yellow],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    blendMode: BlendMode.srcIn,
                    child: const Text(
                      "Empowering Your Financial Future",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Column(
                children:<Widget> [
                   const SizedBox(height :20), 

                   // Email Input Field 
                   TextField (
                     controller :emailController ,
                     decoration :InputDecoration (
                     hintText :"Email" ,
                     hintStyle :const TextStyle (color :Colors.white54 ) ,
                     border :OutlineInputBorder (
                     borderRadius :BorderRadius .circular (18) ,
                     borderSide :BorderSide .none ), fillColor :Colors.purple .withOpacity (0.1) , filled :true , prefixIcon :const Icon (Icons.email ,color :Colors.white ), ), style :const TextStyle (color :Colors.white ), ), 
                   const SizedBox (height :20), 

                   // Password Input Field 
                   TextField (
                     controller :passwordController ,
                     decoration :InputDecoration (
                     hintText :"Password" ,
                     hintStyle :const TextStyle (color :Colors.white54 ) ,
                     border :OutlineInputBorder (
                     borderRadius :BorderRadius .circular (18) ,
                     borderSide :BorderSide .none ), fillColor :Colors.purple .withOpacity (0.1), filled:true , prefixIcon :const Icon (Icons.lock_outline ,color :Colors.white ) ), obscureText:true , style :const TextStyle (color :Colors.white ), ), 
                   const SizedBox (height :20),

                   // Confirm Password Input Field 
                   TextField (
                     controller :confirmPasswordController ,
                     decoration :InputDecoration (
                     hintText :"Confirm Password" ,
                     hintStyle :const TextStyle (color :Colors.white54 ) ,
                     border :OutlineInputBorder (
                     borderRadius :BorderRadius .circular (18) ,
                     borderSide :BorderSide .none ), fillColor :Colors.purple .withOpacity (0.1), filled:true , prefixIcon :const Icon (Icons.lock_outline ,color :Colors.white ) ), obscureText:true , style :const TextStyle (color :Colors.white ), ),

                   const SizedBox(height:
                   20),

                   // Signup Button - Navigate to HomePage
                   ElevatedButton(
                     onPressed:( ) {
                       Navigator.push(context, MaterialPageRoute(builder:(context)=> HomePage()));
                     },
                     style:
                       ElevatedButton.styleFrom(padding:
                       EdgeInsets.symmetric(vertical:
                       15), shape:
                       RoundedRectangleBorder(borderRadius:
                       BorderRadius.circular(18)), backgroundColor:
                       Colors.blueAccent),
                     
                     child:
                       const Text('Sign Up',style:
                       TextStyle(fontSize:
                       18))),
                   
                   const SizedBox(height :
                   20),

                   // Already a user? Link to Login Page 
                   GestureDetector(onTap:( ) {
                       Navigator.push(context, MaterialPageRoute(builder:(_)=>LoginPage()));
                   },
                   
                   child:
                       const Text("Already a user? Log in",style:
                           TextStyle(color:
                           Colors.blueAccent,fontSize:
                           16,decoration:
                           TextDecoration.underline))),
                 ],
               ),
             ],
           ),
         )
       )
     );
   }
}