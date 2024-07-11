import 'package:budget_tracker/common/navigation_helper.dart';
import 'package:budget_tracker/features/transfer/screens/transaction_register_screen.dart';
import 'package:budget_tracker/features/transfer/services/transation_services.dart';
import 'package:budget_tracker/models/transations.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/constants/global_variables.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TransactionService _transactionService = TransactionService();
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    List<Transaction> fetchedTransactions =
        await _transactionService.getRecentTransactions(context);
    setState(() {
      transactions = fetchedTransactions;
    });
  }

  void _navigateToNumberAccountScreen(String imageUrl, String userName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NumberAccountScreen(
          profileImageUrl: imageUrl,
          userName: userName,
        ),
      ),
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: GlobalVariables.backgroundColorGradient,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16), // Additional spacing from top
              const Icon(
                Icons.send_to_mobile,
                size: 150,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              const Text(
                'Transfer',
                style: TextStyle(
                  fontSize: 37,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Last Transaction',
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: transactions.map((transaction) {
                  return GestureDetector(
                    onTap: () => _navigateToNumberAccountScreen(
                      transaction.imageUrl,
                      transaction.recipient,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(transaction.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transaction.recipient,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Or'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => navigateToSearchScreen(context),
                child: const Text('Search Account'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
