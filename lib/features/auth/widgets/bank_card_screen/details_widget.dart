// ignore_for_file: use_build_context_synchronously

import 'package:budget_tracker/constants/utils.dart';
import 'package:budget_tracker/models/transations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_tracker/features/auth/widgets/bank_card_screen/balance_widget.dart';
import 'package:budget_tracker/features/auth/widgets/bank_card_screen/transaction_item.dart';
import 'package:budget_tracker/features/bank_card/services/bank_services.dart';

class DetailsWidget extends StatefulWidget {
  final String selectedOption;
  final String accountName;
  final String accountNumber;
  final String accountCreation;
  final List<Transaction> recentTransactions;

  const DetailsWidget({
    required this.selectedOption,
    required this.accountName,
    required this.accountNumber,
    required this.accountCreation,
    required this.recentTransactions,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DetailsWidgetState createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  double _balance = 0.0;
  double _amountSpent = 0.0;
  bool _isBalanceSet = false;
  // ignore: unused_field
  bool _isAmountSpentSet = false;
  final _balanceController = TextEditingController();
  final _amountSpentController = TextEditingController();
  late BankService _bankService;
  late String _currentMonth;

  @override
  void initState() {
    super.initState();
    _bankService = BankService(context);
    _currentMonth = DateFormat('MMMM').format(DateTime.now());
    _fetchBalance();
  }

  @override
  void dispose() {
    _balanceController.dispose();
    _amountSpentController.dispose();
    super.dispose();
  }

  Future<void> _fetchBalance() async {
    try {
      final response = await _bankService.getBalance(_currentMonth);
      final balance = response['balance'];
      final amountSpent = response['amountSpent'];
      if (balance is int) {
        setState(() {
          _balance = balance.toDouble();
          _isBalanceSet = true;
        });
      } else if (balance is double) {
        setState(() {
          _balance = balance;
          _isBalanceSet = true;
        });
      } else {
        throw Exception('Unexpected balance type');
      }

      if (amountSpent is int) {
        setState(() {
          _amountSpent = amountSpent.toDouble();
          _isAmountSpentSet = true;
        });
      } else if (amountSpent is double) {
        setState(() {
          _amountSpent = amountSpent;
          _isAmountSpentSet = true;
        });
      } else {
        throw Exception('Unexpected amountSpent type');
      }
    } catch (e) {
      setState(() {
        _isBalanceSet = false;
      });
    }
  }

  void _setBalance() async {
    try {
      final balance = double.tryParse(_balanceController.text) ?? 0.0;
      final amountSpent = double.tryParse(_amountSpentController.text) ?? 0.0;

      setState(() {
        _balance = balance;
        _amountSpent = amountSpent;
        _isBalanceSet = true;
        _isAmountSpentSet = true;
      });

      await _bankService.updateBalance(_currentMonth, balance, amountSpent);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.selectedOption) {
      case 'Your Balance':
        return _isBalanceSet
            ? _buildBalanceSection()
            : _buildSetBalanceSection();
      case 'Transaction History':
        return _buildTransactionHistorySection();
      case 'Your Account':
        return _buildAccountDetailsSection();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSetBalanceSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _balanceController,
            decoration: const InputDecoration(
              labelText: 'Set Your Balance',
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _amountSpentController,
            decoration: const InputDecoration(
              labelText: 'Set Amount Spent',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _setBalance,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection() {
    var fb = _balance - _amountSpent;
    var formattedBalance = fb.toStringAsFixed(1);
    return _isBalanceSet
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: BalanceWidget(
              balance: '₹ $formattedBalance',
              amountSpent: '₹ $_amountSpent',
            ),
          )
        : const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          );
  }

  Widget _buildTransactionHistorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.recentTransactions.map((transaction) {
          return TransactionItem(
            transactionId: transaction.transactionId,
            amount: '₹ ${transaction.amount.toStringAsFixed(2)}',
            date: DateFormat('yyyy-MM-dd').format(transaction.date),
            time: DateFormat('HH:mm').format(transaction.date),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAccountDetailsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('Account Name   ', widget.accountName),
          _buildDetailItem(
              'Account Number   ', _censorAccountNumber(widget.accountNumber)),
          _buildDetailItem('Account Status   ', 'Active'),
          _buildDetailItem('Account Created On   ', widget.accountCreation),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              flex: 2,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 3,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String _censorAccountNumber(String accountNumber) {
    if (accountNumber.length > 4) {
      return accountNumber.replaceRange(
          0, accountNumber.length - 4, '*' * (accountNumber.length - 4));
    }
    return accountNumber;
  }
}
