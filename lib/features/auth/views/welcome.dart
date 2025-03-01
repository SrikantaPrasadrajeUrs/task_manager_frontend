import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/enums.dart';
import 'package:task_manager/features/auth/views/sign_up.dart';
import 'package:task_manager/features/auth/views/sign_in.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  void navigateToSignUpPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUp()));
  }

  void navigateToSignInPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignIn()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87CEFA), Color(0xFF4682B4)], // Sky blue gradient
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ConstantSizes.horizontalPadding),
          child: Column(
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 270,
                    width: 270,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                  Transform.rotate(
                    angle: -8 * pi / 180,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/img1.jpg",
                        height: 240,
                        width: 240,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => navigateToSignInPage(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5), // Deep sky blue
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => navigateToSignUpPage(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF64B5F6), // Lighter sky blue
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Sign Up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
