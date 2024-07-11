import 'package:budget_tracker/common/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/constants/global_variables.dart';
// Import the navigation helper

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  static const String routeName = '/get-started';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/get_started.png',
                height: 300,
                width: 300,
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to Budget Tracker!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => navigateToAuthScreen(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: GlobalVariables
                      .selectedNavBarColor, // Set the background color
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
