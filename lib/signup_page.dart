import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart'; // For custom fonts
import 'package:page_transition/page_transition.dart'; // For page transitions
import 'home_page.dart'; // Import HomePage here
import 'LoginPage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // For Google Sign-In
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:<Widget> [
                  // Logo at the top (Infinity Logo)
                  const SizedBox(height: 50),
                  Image.asset('assets/stipator_logo-rg.png', height :120,width :120), 
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

                  // Email Input Field
                  _buildTextField(emailController, "Email", Icons.email_outlined),

                  const SizedBox(height :20),

                  // Password Input Field
                  _buildTextField(passwordController, "Password", Icons.lock_outline, obscureText:true),

                  const SizedBox(height :20),

                  // Confirm Password Input Field
                  _buildTextField(confirmPasswordController, "Confirm Password", Icons.lock_outline, obscureText:true),

                  const SizedBox(height :30),

                  // Sign Up Button (Gradient)
                  ElevatedButton(
                    onPressed: () {
                      _signUp(context, emailController.text, passwordController.text, confirmPasswordController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor:
                        Colors.blueAccent, // Use backgroundColor instead of primary
                    ),
                    child:
                      Container(
                        width :double.infinity ,
                        alignment :Alignment.center ,
                        child :
                          const Text('Sign Up',style :
                            TextStyle(fontSize :18,color :Colors.white )),
                      )
                   ),

                   const SizedBox(height :20),

                   // OR Divider
                   Row(children:<Widget> [
                     Expanded(child:
                       Divider(color:
                       Colors.grey[600],thickness:
                       1)),const Padding(padding:
                       EdgeInsets.symmetric(horizontal:
                       10),child:
                       Text("OR",style:
                       TextStyle(color:
                       Colors.grey,fontWeight:
                       FontWeight.w600 ))),Expanded(child:
                       Divider(color:
                       Colors.grey[600],thickness:
                       1))
                   ]),

                   const SizedBox(height :20),

                   // Google Sign Up Button (Gradient)
                   ElevatedButton.icon(
                     onPressed :(){
                       _signInWithGoogle(context);
                     },
                     icon :
                     Icon(Icons.account_circle,color :
                     Colors.white ),label :
                     Text('Sign Up with Google',style :
                     TextStyle(color :
                     const Color.fromARGB(255, 16, 16, 16) )),
                     style :
                     ElevatedButton.styleFrom(padding :
                     EdgeInsets.symmetric(vertical :
                     15),shape :
                     RoundedRectangleBorder(borderRadius :
                     BorderRadius.circular(30)),backgroundColor :
                     const Color.fromRGBO(179, 227, 224, 1),// Use backgroundColor instead of primary 
                   )
                 ),

                 const SizedBox(height :30),

                 // Already have an account? Log In 
                 Row(mainAxisAlignment :
                 MainAxisAlignment.center ,children:[
                   const Text("Already have an account?",style :
                   TextStyle(color :
                   Colors.white70 )),
                   GestureDetector(onTap :
                   (){ Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage())); },child :
                   const Text(" Log In",style :
                   TextStyle(color :
                   Color(0xFF00C6FF),fontWeight :
                   FontWeight.bold ))),
                 ]
               )
             ],
           ),
         ),
       )
    
         ) )
   );
 }

 // Build a custom text field with rounded corners and icon 
 Widget _buildTextField(TextEditingController controller,String hintText ,IconData iconData,{bool obscureText =false }) {
   return TextField(controller :
   controller ,decoration :
   InputDecoration(hintText :
   hintText ,hintStyle :
   const TextStyle(color :
   Colors.grey ),prefixIcon :
   Icon(iconData,color :
   Colors.grey ),filled:true ,fillColor :
   Colors.white.withOpacity(0.1),border :
   OutlineInputBorder(borderRadius :
   BorderRadius.circular(30),borderSide :
   BorderSide.none)),obscureText :
   obscureText ,style :
   const TextStyle(color :
   Colors.white ));
 }

 // Sign-up with Firebase Authentication (Email/Password) 
 Future<void> _signUp(BuildContext context,String email,String password,String confirmPassword ) async {
   if(password !=confirmPassword ){
     _showErrorDialog(context ,"Passwords do not match.");
     return ;
   }

   try{
     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email :email ,password :password );
     
     // Navigate to HomePage after successful signup 
     _navigateToHome(context );
   }on FirebaseAuthException catch (e){
     if(e.code =='weak-password'){
       _showErrorDialog(context ,"The password provided is too weak.");
     }else if(e.code =='email-already-in-use'){
       _showErrorDialog(context ,"The account already exists for that email.");
     }
   }catch(e){
     _showErrorDialog(context ,"An error occurred. Please try again.");
   }
 }

 // Google Sign-In Logic 
 Future<void> _signInWithGoogle(BuildContext context) async {
   try{
     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
     if(googleUser ==null )return ;// User canceled sign-in 

     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
     
     final OAuthCredential credential = GoogleAuthProvider.credential(accessToken :googleAuth.accessToken ,idToken :googleAuth.idToken );

     UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential );

     // Navigate to HomePage after successful sign-up 
     Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: HomePage()));
     
   }catch(e){
    print("Error signing in with Google:$e");
   }
 }

 // Custom navigation function with transition to HomePage 
 void _navigateToHome(BuildContext context) {
   Navigator.pushReplacement(context ,
    PageRouteBuilder(pageBuilder :(context ,animation ,secondaryAnimation )=>HomePage(),
      transitionsBuilder :(context ,animation ,secondaryAnimation ,child ){
        const begin = Offset(1.0 ,0.0 );// Slide from right 
        const end = Offset.zero ;
        final tween = Tween(begin :begin ,end :end );
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position :offsetAnimation ,child :child );
      },
    ),
   );
 }

 // Show error dialog 
 void _showErrorDialog(BuildContext context,String message ) {
   showDialog(context :context ,builder :(context )=>AlertDialog(title :
    const Text("Error"),content :Text(message ),actions:[
    ElevatedButton(onPressed :()=>Navigator.pop(context ),child :const Text("OK"))
    ]
   )
 );
 }
}