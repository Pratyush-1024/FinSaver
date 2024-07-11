import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:budget_tracker/constants/global_variables.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
        title: const Text('Help & Support'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: GlobalVariables.backgroundColorGradient,
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Help & Support Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'How can we help you?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'If you have any questions or issues with the app, feel free to contact our support team. We are here to assist you with any problems you encounter while using Budget Tracker.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Email: support@budgettracker.com\nPhone: +1-123-456-7890',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              _buildFAQItem(
                question: 'How do I add a new transaction?',
                answer:
                    'To add a new transaction, go to the Transactions screen and tap on the "+" button. Enter the details and save.',
              ),
              _buildFAQItem(
                question: 'How can I change my account settings?',
                answer:
                    'You can change your account settings in the Account screen. Tap on the edit icon next to the setting you want to change.',
              ),
              _buildFAQItem(
                question: 'What should I do if I forget my password?',
                answer:
                    'If you forget your password, you can reset it using the "Forgot Password" option on the login screen.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      textColor: Colors.white,
      iconColor: Colors.white,
      collapsedTextColor: Colors.white,
      collapsedIconColor: Colors.white,
      backgroundColor: Colors.white.withOpacity(0.1),
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            answer,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
