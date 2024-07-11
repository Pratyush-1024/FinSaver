// ignore_for_file: use_build_context_synchronously

import 'package:budget_tracker/constants/utils.dart';
import 'package:budget_tracker/features/add_details/screens/add_details.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/features/add_card/services/add_card_services.dart';

class AddCard extends StatefulWidget {
  static const String routeName = '/add-card';
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final AddCardService _addCardService = AddCardService();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();

  void _addCardDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Account Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    hintText: 'Phone Number',
                  ),
                ),
                TextField(
                  controller: accountNumberController,
                  decoration: const InputDecoration(
                    hintText: 'Account Number',
                  ),
                ),
                TextField(
                  controller: accountNameController,
                  decoration: const InputDecoration(
                    hintText: 'Account Name',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _saveAccountDetails(
                  phoneNumberController.text,
                  accountNumberController.text,
                  accountNameController.text,
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveAccountDetails(
    String phoneNumber,
    String accountNumber,
    String accountName,
  ) async {
    try {
      bool success = await _addCardService.createUserBankDetail(
        context: context,
        accountName: accountName,
        accountNumber: accountNumber,
        phoneNumber: phoneNumber,
      );

      if (success) {
        Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, AddDetails.routeName);
      } else {
        showSnackBar(context, 'Failed to save account details.');
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: GlobalVariables.backgroundColorGradient,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Add Account',
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: _addCardDetails,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Container(
                        width: 290,
                        height: 400,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              GlobalVariables.primaryColor,
                              GlobalVariables.selectedNavBarColor,
                            ],
                            stops: const [0.5, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Stack(
                          children: [
                            const Positioned(
                              bottom: 10,
                              left: 10,
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: Text(
                                  'FIN SAVE',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.account_balance,
                                  color: Colors.white,
                                  size: 45,
                                ),
                                const SizedBox(width: 10),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(0.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.add,
                                        color: Colors.black, size: 30),
                                    onPressed: _addCardDetails,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tap on the add button to enter your bank details.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
