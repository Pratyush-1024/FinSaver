// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:budget_tracker/constants/utils.dart';
import 'package:budget_tracker/models/savings_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:budget_tracker/constants/error_handling.dart';
import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/providers/user_provider.dart';

class BankService {
  final BuildContext context;

  BankService(this.context);

  Future<Map<String, dynamic>> getBalance(String month) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await http.get(
        Uri.parse('$uri/api/balance/$month'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {},
      );

      return jsonDecode(response.body);
    } catch (e) {
      showSnackBar(context, 'Failed to get balance: $e');
      return {'balance': 0.0, 'amountSpent': 0.0};
    }
  }

  Future<void> updateBalance(
      String month, double balance, double amountSpent) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await http.post(
        Uri.parse('$uri/api/balance/update'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'month': month,
          'balance': balance,
          'amountSpent': amountSpent,
        }),
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          // Optionally handle success if needed
        },
      );
    } catch (e) {
      showSnackBar(context, 'Failed to update balance: $e');
    }
  }

  Future<int> getLastUpdateMonth() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await http.get(
        Uri.parse('$uri/api/balance/lastUpdateMonth'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          // Optionally handle success if needed
        },
      );

      final data = jsonDecode(response.body);
      return data['lastUpdateMonth'];
    } catch (e) {
      showSnackBar(context, 'Failed to get last update month: $e');
      return 0;
    }
  }

  Future<List<SavingsData>> getAllMonthsData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final List<SavingsData> allMonthsData = [];
    try {
      final url = '$uri/api/balance/all';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {},
      );

      final jsonData = jsonDecode(response.body);
      if (jsonData is List) {
        for (var data in jsonData) {
          final savingsData = SavingsData.fromJson(data);
          allMonthsData.add(savingsData);
        }
      } else {
        showSnackBar(context, 'Unexpected data format');
      }
    } catch (e) {
      showSnackBar(context, 'Failed to fetch savings data: $e');
    }

    return allMonthsData;
  }
}
