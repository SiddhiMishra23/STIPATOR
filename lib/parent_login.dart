import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'parent_home_page.dart'; // Import the correct parent home page
import 'parent_signup.dart'; // Import the parent sign-up page

class ParentLoginPage extends StatefulWidget {
  const ParentLoginPage({super.key});

  @override
  _ParentLoginPageState createState() => _ParentLoginPageState();
}

class _ParentLoginPageState extends State<ParentLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Password visibility toggle state
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E3C72),
              Color(0xFF2A5298),
            ],
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
              children: <Widget>[
                const SizedBox(height: 50),
                Image.asset('assets/stipator_logo_rg.png',
                    height: 120, width: 120), // Replace with your logo
                const SizedBox(height: 20),
                Text(
                  "STIPATOR",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Parent Login",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey[300],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(
                    emailController, "Email", Icons.email_outlined),
                const SizedBox(height: 20),
                _buildPasswordField(passwordController, "Password",
                    _obscurePassword, () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                }),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    _login(context, emailController.text,
                        passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.blue, // Button color
                    foregroundColor: Colors.white, // Text color
                  ),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParentSignUpPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
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

  Future<void> _login(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ParentHomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorDialog(context, "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        _showErrorDialog(context, "Wrong password provided.");
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
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
