// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:budget_tracker/constants/error_handling.dart';
import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/constants/utils.dart';
import 'package:budget_tracker/features/bank_card/services/bank_services.dart';
import 'package:budget_tracker/models/transations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionService {
  Future<String?> createTransaction({
    required BuildContext context,
    required String recipient,
    required double amount,
    required String type,
    required String imageUrl,
    required String month,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      http.Response res = await http.post(
        Uri.parse('$uri/api/transactions/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token ?? '',
        },
        body: jsonEncode({
          'recipient': recipient,
          'amount': amount,
          'type': type,
          'imageUrl': imageUrl,
          'month': month,
        }),
      );

      if (res.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(res.body);
        String transactionId = responseData['transactionId'];

        BankService bankService = BankService(context);
        var balanceData = await bankService.getBalance(month);

        double newBalance = balanceData['balance'] is int
            ? (balanceData['balance'] as int).toDouble()
            : balanceData['balance'];
        double newAmountSpent = balanceData['amountSpent'] is int
            ? (balanceData['amountSpent'] as int).toDouble()
            : balanceData['amountSpent'];
        await bankService.updateBalance(month, newBalance, newAmountSpent);

        return transactionId;
      } else {
        httpErrorHandling(
          response: res,
          context: context,
          onSuccess: () {},
        );
        return null;
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e');
      return null;
    }
  }

  Future<List<Transaction>> getRecentTransactions(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      http.Response res = await http.get(
        Uri.parse('$uri/api/transactions/recent'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token ?? '',
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          // Handle success if needed
        },
      );

      if (res.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(res.body);
        List<Transaction> transactions =
            jsonList.map((json) => Transaction.fromJson(json)).toList();

        if (transactions.length > 4) {
          transactions = transactions.sublist(0, 5);
        }

        return transactions;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e');
      return [];
    }
  }

  Future<List<Transaction>> getTransactions(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      http.Response res = await http.get(
        Uri.parse('$uri/api/transactions'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token ?? '',
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          // Handle success if needed
        },
      );

      if (res.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(res.body);
        List<Transaction> transactions =
            jsonList.map((json) => Transaction.fromJson(json)).toList();
        return transactions;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e');
      return [];
    }
  }
}
