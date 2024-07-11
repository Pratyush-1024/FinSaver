// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:budget_tracker/constants/error_handling.dart';
import 'package:budget_tracker/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/providers/user_provider.dart';

class UserMoreDetailsService {
  Future<bool> createUserMoreDetails({
    required BuildContext context,
    required String address,
    DateTime? memberSince,
    required String bio,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/more-details/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'address': address,
          'memberSince': memberSince?.toIso8601String(),
          'bio': bio,
        }),
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {},
      );

      return res.statusCode == 201;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<Map<String, String>?> getUserMoreDetails({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/more-details/get/${userProvider.user.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          // Any additional success handling can go here
        },
      );

      Map<String, dynamic> data = jsonDecode(res.body);
      if (data.isNotEmpty) {
        DateTime? memberSince = data['memberSince'] != null
            ? DateTime.parse(data['memberSince'])
            : null;
        String formattedDate = memberSince != null
            ? DateFormat('MMMM yyyy').format(memberSince)
            : '';
        Map<String, String> userMoreDetails = {
          'address': data['address'].toString(),
          'memberSince': formattedDate,
          'bio': data['bio'].toString(),
        };
        return userMoreDetails;
      } else {
        return null; // Handle no data scenario if needed
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return null;
    }
  }

  Future<bool> updateUserMoreDetails({
    required BuildContext context,
    required String address,
    DateTime? memberSince,
    required String bio,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.patch(
        Uri.parse('$uri/api/more-details/update/${userProvider.user.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'address': address,
          'memberSince': memberSince?.toIso8601String(),
          'bio': bio,
        }),
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          // Any additional success handling can go here
        },
      );

      return res.statusCode ==
          200; // Ensure this matches your backend's success status code
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<bool> deleteUserMoreDetails({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/more-details/delete/${userProvider.user.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          // Any additional success handling can go here
        },
      );

      return res.statusCode ==
          200; // Ensure this matches your backend's success status code
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }
}
