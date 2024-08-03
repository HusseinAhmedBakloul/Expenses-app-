import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup/login/Signin.dart';
import 'package:signup/pages/Homescreen.dart';
import 'package:signup/pages/welcomescreen.dart';

class HalfClippedRectClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.cubicTo(
      size.width / 2,
      size.height - (size.height / 4),
      3 * (size.width / 2),
      size.height,
      size.width,
      size.height - (size.height / 8),
    );
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isNameEmpty = false;
  bool isEmailEmpty = false;
  bool isPasswordEmpty = false;

  Future<void> login() async {
    setState(() {
      isNameEmpty = nameController.text.trim().isEmpty;
      isEmailEmpty = emailController.text.trim().isEmpty;
      isPasswordEmpty = passwordController.text.trim().isEmpty;
    });

    if (isNameEmpty || isEmailEmpty || isPasswordEmpty) {
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await userCredential.user!.updateProfile(displayName: nameController.text.trim());

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homescreen()),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          ClipPath(
            clipper: HalfClippedRectClipper(),
            child: Container(
              color: Colors.white,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 120),
                    child: Text(
                      'Welcome back to',
                      style: TextStyle(color: Colors.black, fontSize: 28,fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Row(
                    children: [
                      Text(
                        'Master',
                        style: TextStyle(color: primaryColor, fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'AbrilFatface'),
                      ),
                      Text(
                        'Mind.',
                        style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'AbrilFatface'),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Text(
                      'Create Account',
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  buildTextField(
                      controller: nameController,
                      icon: Icons.person,
                      hintText: 'Enter your name',
                      isEmpty: isNameEmpty),
                  const SizedBox(height: 20),
                  buildTextField(
                      controller: emailController,
                      icon: Icons.email,
                      hintText: 'Enter your email',
                      isEmpty: isEmailEmpty),
                  const SizedBox(height: 20),
                  buildTextField(
                      controller: passwordController,
                      icon: Icons.lock,
                      hintText: 'Enter your password',
                      obscureText: true,
                      isEmpty: isPasswordEmpty),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    onPressed: login,
                    child: const Text('Create Account',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  Center(
                      child: Text(
                        'Already have an account?',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.grey)
                       )
                      ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => const Signin()),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Login here',
                        style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,decorationColor: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
      {required TextEditingController controller,
      required IconData icon,
      required String hintText,
      bool obscureText = false,
      required bool isEmpty}) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(78, 226, 225, 225),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 1,
          color: isEmpty ? Colors.red : primaryColor,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(icon,
                color: primaryColor, size: 24),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
