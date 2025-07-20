import 'dart:async';
import 'package:flutter/material.dart';
import 'package:management/AuthScreen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 30), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),

            Image.asset(
              "assets/images/img.png",
              height: 90,
              width: 90,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 1),

            const Text(
              "BizManager",
              style: TextStyle(
                fontFamily: 'Font',
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 1),

            const Text(
              "Smartly manage your business\nwith efficiency and clarity.",
              style: TextStyle(
                fontFamily: 'Font1',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(flex: 2),

            const Padding(
              padding: EdgeInsets.only(bottom: 60),
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 4.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
