import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'home_page.dart';
import 'loginPage.dart';
import 'parent_signup.dart'; // Ensure this import is correct

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

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
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              Image.asset('assets/stipator_logo_rg.png',
                  height: 120, width: 120),
              const SizedBox(height: 20),
              Text(
                "STIPATOR",
                style: GoogleFonts.righteous(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Empowering Your Safety",
                style: GoogleFonts.lora(
                  fontSize: 22,
                  color: Colors.grey[300],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField(emailController, "Email", Icons.email_outlined),
              const SizedBox(height: 20),
              _buildTextField(
                  passwordController, "Password", Icons.lock_outline,
                  obscureText: _isPasswordHidden, toggleObscureText: () {
                setState(() {
                  _isPasswordHidden = !_isPasswordHidden;
                });
              }),
              const SizedBox(height: 20),
              _buildTextField(confirmPasswordController, "Confirm Password",
                  Icons.lock_outline, obscureText: _isConfirmPasswordHidden,
                  toggleObscureText: () {
                setState(() {
                  _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                });
              }),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _signUp(context, emailController.text,
                      passwordController.text, confirmPasswordController.text);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.blueAccent,
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text('Sign Up',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ParentSignUpPage()));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.blueAccent,
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text('Parent Sign Up',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Divider(color: Colors.grey[600], thickness: 1)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("OR",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w600)),
                  ),
                  Expanded(
                      child: Divider(color: Colors.grey[600], thickness: 1)),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  _signInWithGoogle(context);
                },
                icon: const Icon(Icons.account_circle, color: Colors.white),
                label: const Text('Sign Up with Google',
                    style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: const Color.fromRGBO(179, 227, 224, 1),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?",
                      style: TextStyle(color: Colors.white70)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: const Text(" Log In",
                        style: TextStyle(
                            color: Color(0xFF00C6FF),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData iconData,
      {bool obscureText = false, VoidCallback? toggleObscureText}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(iconData, color: Colors.grey),
        suffixIcon: toggleObscureText != null
            ? IconButton(
                icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey),
                onPressed: toggleObscureText,
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        PageTransition(type: PageTransitionType.fade, child: const HomePage()),
      );
    } catch (e) {
      print(e);
    }
  }

  void _signUp(BuildContext context, String email, String password,
      String confirmPassword) async {
    if (password != confirmPassword) {
      // Show error if passwords do not match
      _showErrorDialog(context, "Passwords do not match!");
      return;
    }

    try {
      // Show loading indicator while signing up
      showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Create the user using Firebase Authentication
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Dismiss loading indicator
      Navigator.of(context).pop();

      // Navigate to HomePage on successful sign-up
      Navigator.pushReplacement(
        context,
        PageTransition(type: PageTransitionType.fade, child: const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Dismiss loading indicator
      if (e.code == 'email-already-in-use') {
        _showErrorDialog(context, 'The email is already in use.');
      } else if (e.code == 'weak-password') {
        _showErrorDialog(context, 'The password is too weak.');
      } else {
        _showErrorDialog(context, e.message!);
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
