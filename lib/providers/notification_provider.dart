import 'package:flutter/material.dart';
import 'package:budget_tracker/features/notifications/service/notifications_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  List<Map<String, String>> _notifications = [];

  List<Map<String, String>> get notifications => _notifications;

  Future<void> fetchNotifications(BuildContext context) async {
    _notifications =
        await _notificationService.getAllNotifications(context: context);
    notifyListeners();
  }
}
