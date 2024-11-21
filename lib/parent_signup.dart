import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'parent_home_page.dart';
import 'parent_login.dart';

class ParentSignUpPage extends StatefulWidget {
  const ParentSignUpPage({super.key});

  @override
  _ParentSignUpPageState createState() => _ParentSignUpPageState();
}

class _ParentSignUpPageState extends State<ParentSignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF283048),
              Color(0xFF859398),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    "Empowering Your Child's Safety",
                    style: GoogleFonts.lora(
                      fontSize: 22,
                      color: Colors.grey[300],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text("Create Account",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 20),
                  _buildTextField(
                      emailController, "Email", Icons.email_outlined),
                  const SizedBox(height: 20),
                  _buildPasswordField(passwordController, "Password",
                      _obscurePassword, () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  }),
                  const SizedBox(height: 20),
                  _buildPasswordField(confirmPasswordController,
                      "Confirm Password", _obscureConfirmPassword, () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  }),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (passwordController.text ==
                          confirmPasswordController.text) {
                        _signUp(context, emailController.text,
                            passwordController.text);
                      } else {
                        _showErrorDialog(context, "Passwords do not match.");
                      }
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ParentLoginPage()),
                      );
                    },
                    child: const Text("Already have an account? Log in",
                        style: TextStyle(color: Colors.white54)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData iconData) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(iconData, color: Colors.grey),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hintText,
      bool obscureText, VoidCallback onToggle) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Future<void> _signUp(BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      _navigateToParentHome(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showErrorDialog(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        _showErrorDialog(context, "An account already exists for that email.");
      }
    }
  }

  void _navigateToParentHome(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const ParentHomePage()));
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK")),
          ]),
    );
  }
}
