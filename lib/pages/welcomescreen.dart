import 'package:flutter/material.dart';
import 'package:signup/pages/Homescreen.dart';

class Welcomescreen extends StatelessWidget {
  const Welcomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Image.asset(
              'images/Screenshot_2024-07-26_171919-removebg-preview.png',
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height * 0.35,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Text('Image not found!', style: TextStyle(color: Colors.red));
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text(
              'Easy way to Manage your Money',
              style: TextStyle(color: Colors.black, fontSize: 34, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'The invoice management app helps users track and organize their bills and expenses, with features like invoice recording, categorization, and payment management.',
              style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Row(
              children: [
                Text(
                  'Get Started',
                  style: TextStyle(color: Color.fromARGB(255, 58, 55, 199), fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Homescreen()),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 58, 55, 199),
                    ),
                    child: Icon(Icons.arrow_right_alt_outlined, color: Colors.white, size: 32),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30), 
          ],
        ),
      ),
    );
  }
}
