// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:budget_tracker/constants/utils.dart';
import 'package:budget_tracker/features/bank_card/services/bank_services.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/features/auth/widgets/savings_card.dart';
import 'package:budget_tracker/features/auth/widgets/transaction_card.dart';
import 'package:budget_tracker/features/auth/widgets/transaction_list.dart';
import 'package:budget_tracker/features/auth/widgets/savings_graph.dart';
import 'package:budget_tracker/providers/user_provider.dart';
import 'package:budget_tracker/providers/notification_provider.dart';
import 'package:budget_tracker/features/notifications/screens/notifications_screen.dart';
import 'package:budget_tracker/common/navigation_helper.dart'; // Import navigateToSettingsPage
import 'package:budget_tracker/features/add_card/services/add_card_services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BankService _bankService;
  int selectedIndex = 0;
  String accountName = '';
  double _amountSpent = 0.0;
  double _balance = 0.0;

  @override
  void initState() {
    super.initState();
    _bankService = BankService(context);

    Provider.of<NotificationProvider>(context, listen: false)
        .fetchNotifications(context);

    _fetchAccountName();
    _fetchBalance(); // Fetch initial balance and amount spent
  }

  Future<void> _fetchAccountName() async {
    final addCardService = AddCardService();
    final accountDetails =
        await addCardService.getUserBankDetail(context: context);

    if (accountDetails != null) {
      setState(() {
        accountName = accountDetails['accountName'] ?? '';
      });
    }
  }

  Future<void> _fetchBalance() async {
    try {
      final now = DateTime.now();
      final selectedMonth = _getMonthName(now.month);
      final response = await _bankService.getBalance(selectedMonth);

      if (response.containsKey('balance') &&
          response.containsKey('amountSpent')) {
        final balance = response['balance'];
        final amountSpent = response['amountSpent'];

        setState(() {
          _balance = balance is int ? balance.toDouble() : balance;
          _amountSpent =
              amountSpent is int ? amountSpent.toDouble() : amountSpent;

          double savingsAmount = _balance - _amountSpent;
          _savingsAmount = savingsAmount;
        });
      } else {
        showSnackBar(context,
            'Response does not contain expected keys: balance or amountSpent');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  double _savingsAmount = 0.0;

  String _getMonthName(int month) {
    switch (month) {
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
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined,
                    color: Colors.white),
                iconSize: 30,
                onPressed: () {
                  List<Map<String, String>> notifications =
                      Provider.of<NotificationProvider>(context, listen: false)
                          .notifications;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          NotificationsScreen(notifications: notifications),
                    ),
                  );
                },
              ),
              Consumer<NotificationProvider>(
                builder: (context, notificationProvider, child) {
                  if (notificationProvider.notifications.isNotEmpty) {
                    return Positioned(
                      right: 9,
                      top: 9,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              iconSize: 30,
              onPressed: () {
                navigateToSettingsPage(context);
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.backgroundColorGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Hello ${user.name}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 240,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        child: buildTransactionCard(
                          context,
                          accountName,
                          'Transaction',
                          const [Color(0xFF3A3A3A), Color(0xFF616161)],
                          _amountSpent, // Pass _amountSpent here
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        child: buildSavingsCard(
                          context,
                          accountName,
                          'Savings',
                          const [Color(0xFF1C3A4F), Color(0xFF4F6D7A)],
                          _savingsAmount,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              'Transactions',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: selectedIndex == 0
                                    ? Colors.white
                                    : Colors.white70,
                              ),
                            ),
                            if (selectedIndex == 0)
                              Container(
                                margin: const EdgeInsets.only(top: 4.0),
                                height: 4.0,
                                width: 30.0,
                                color: Colors.blue,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 25.0),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              'Savings',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: selectedIndex == 1
                                    ? Colors.white
                                    : Colors.white70,
                              ),
                            ),
                            if (selectedIndex == 1)
                              Container(
                                margin: const EdgeInsets.only(top: 4.0),
                                height: 4.0,
                                width: 30.0,
                                color: Colors.blue,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 64.0),
                    child: selectedIndex == 0
                        ? const TransactionList()
                        : const NewSavingsGraph(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
