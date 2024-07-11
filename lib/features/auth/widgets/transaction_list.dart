import 'package:budget_tracker/features/transfer/services/transation_services.dart';
import 'package:budget_tracker/models/transations.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late Future<List<Transaction>> _futureTransactions;

  @override
  void initState() {
    super.initState();
    _futureTransactions = _fetchTransactions();
  }

  Future<List<Transaction>> _fetchTransactions() async {
    try {
      return await TransactionService().getTransactions(context);
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Transaction>>(
      future: _futureTransactions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Failed to fetch transactions'));
        } else {
          List<Transaction> transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                leading: Image.network(transaction.imageUrl),
                title: Text(
                  transaction.recipient,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  transaction.type == 'income' ? 'Income' : 'Withdrawal',
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  '₹${transaction.amount.abs().toStringAsFixed(3)}',
                  style: TextStyle(
                    color: transaction.type == 'income'
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
