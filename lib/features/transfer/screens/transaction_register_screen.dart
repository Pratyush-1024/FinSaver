// ignore_for_file: use_build_context_synchronously

import 'package:budget_tracker/common/custom_dropdown.dart';
import 'package:budget_tracker/common/custom_keyboard.dart';
import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/constants/utils.dart';
import 'package:budget_tracker/features/notifications/service/notifications_service.dart';
import 'package:budget_tracker/features/transfer/services/transation_services.dart';
import 'package:flutter/material.dart';

class NumberAccountScreen extends StatefulWidget {
  static const routeName = '/number-account';

  final String profileImageUrl;
  final String userName;

  const NumberAccountScreen({
    super.key,
    required this.profileImageUrl,
    required this.userName,
  });

  @override
  State<NumberAccountScreen> createState() => _NumberAccountScreenState();
}

class _NumberAccountScreenState extends State<NumberAccountScreen> {
  String amount = '';
  String currentMonth = '';
  _NumberAccountScreenState() {
    currentMonth = _getMonthName(DateTime.now().month);
  }
  final DropdownLogic dropdownLogic = DropdownLogic();
  bool _isProcessing = false;

  String _getMonthName(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        throw Exception('Invalid month number');
    }
  }

  @override
  void initState() {
    currentMonth = _getMonthName(DateTime.now().month);
    super.initState();
  }

  void onKeyTap(String keyLabel) {
    setState(() {
      if (keyLabel == '<') {
        if (amount.isNotEmpty) {
          amount = amount.substring(0, amount.length - 1);
        }
      } else if (keyLabel == '.') {
        if (!amount.contains('.') && amount.isNotEmpty) {
          amount += keyLabel;
        }
      } else if (RegExp(r'[0-9]').hasMatch(keyLabel)) {
        amount += keyLabel;
      }
    });
  }

  void registerTransaction() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      double parsedAmount = double.parse(amount);

      TransactionService transactionService = TransactionService();
      String? transactionId = await transactionService.createTransaction(
        context: context,
        recipient: widget.userName,
        amount: parsedAmount,
        type: dropdownLogic.dropdownValue.toLowerCase(),
        imageUrl: widget.profileImageUrl,
        month: currentMonth,
      );
      if (transactionId != null) {
        NotificationService().createNotification(
          context: context,
          title: 'Transaction Process',
          body:
              'Go to your UPI App and match the same transaction to keep track with your monthly budget goal!',
        );

        NotificationService.showNotification(
          context,
          'Go to your UPI App and match the same transaction to keep track with your monthly budget goal!',
        );

        await Future.delayed(const Duration(seconds: 5));

        navigateToPaymentSuccessScreen(context, {
          'recipient': widget.userName,
          'amount': amount,
          'date': DateTime.now().toString(),
          'transactionId': transactionId,
        });
      } else {
        showSnackBar(context, 'Transaction failed.');
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void navigateToPaymentSuccessScreen(
      BuildContext context, Map<String, String> transactionDetails) {
    Navigator.of(context).pushNamed(
      '/payment-success',
      arguments: transactionDetails,
    );
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
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: GlobalVariables.backgroundColorGradient,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Centered Avatar Image
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(widget.profileImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Name
            Center(
              child: Text(
                widget.userName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: dropdownLogic.buildDropdownButton((newValue) {
                setState(() {
                  dropdownLogic.dropdownValue = newValue;
                });
              }),
            ),
            const SizedBox(height: 16),

            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter amount',
                hintStyle: const TextStyle(color: Colors.white54),
              ),
              keyboardType: TextInputType.none,
              readOnly: true,
              controller: TextEditingController(
                text: amount,
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
            const SizedBox(height: 16),

            CustomKeyboard(onKeyTap: onKeyTap),
            const SizedBox(height: 16),

            Center(
              child: _isProcessing
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: registerTransaction,
                      child: const Text('Register'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
