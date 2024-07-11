// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:budget_tracker/constants/error_handling.dart';
import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/constants/utils.dart';
import 'package:budget_tracker/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddCardService {
  Future<bool> createUserBankDetail({
    required BuildContext context,
    required String accountName,
    required String accountNumber,
    required String phoneNumber,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/userBankDetails/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'accountName': accountName,
          'accountNumber': accountNumber,
          'phoneNumber': phoneNumber,
        }),
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {},
      );

      return res.statusCode == 200;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<Map<String, String>?> getUserBankDetail({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/userBankDetails/get/${userProvider.user.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {},
      );

      Map<String, dynamic> data = jsonDecode(res.body);
      if (data.isNotEmpty) {
        DateTime updatedAt = DateTime.parse(data['updatedAt']);
        String formattedDate = DateFormat('yyyy-MM-dd').format(updatedAt);
        Map<String, String> userBankDetail = {
          '_id': data['_id'].toString(),
          'accountName': data['accountName'].toString(),
          'accountNumber': data['accountNumber'].toString(),
          'phoneNumber': data['phoneNumber'].toString(),
          'updatedAt': formattedDate,
        };
        return userBankDetail;
      } else {
        return null;
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return null;
    }
  }

  Future<bool> updateUserBankDetails({
    required BuildContext context,
    required String accountName,
    required String accountNumber,
    required String phoneNumber,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.put(
        Uri.parse('$uri/api/userBankDetails/update/${userProvider.user.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'accountName': accountName,
          'accountNumber': accountNumber,
          'phoneNumber': phoneNumber,
        }),
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {},
      );

      return res.statusCode == 200;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  void deleteUserBankDetail({
    required BuildContext context,
    required String userBankDetailId,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/userBankDetails/delete/$userBankDetailId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
