// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:budget_tracker/constants/error_handling.dart';
import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/constants/utils.dart';
import 'package:budget_tracker/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class NotificationService {
  void createNotification({
    required BuildContext context,
    required String title,
    required String body,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/notification/create'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'title': title,
          'body': body,
        }),
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          // Handle success if needed
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void deleteNotification({
    required BuildContext context,
    required String notificationId,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/notification/$notificationId'),
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

  static void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<List<Map<String, String>>> getAllNotifications({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/notification/all'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          // Handle success if needed
        },
      );

      List<dynamic> data = jsonDecode(res.body);
      List<Map<String, String>> notifications = data
          .map((e) => {
                '_id': e['_id'].toString(), // Ensure '_id' is included
                'title': e['title']
                    .toString(), // Ensure 'title' is converted to String
                'body': e['body']
                    .toString(), // Ensure 'body' is converted to String
              })
          .toList();

      return notifications;
    } catch (e) {
      showSnackBar(context, e.toString());
      return []; // Return empty list or handle error as needed
    }
  }
}
