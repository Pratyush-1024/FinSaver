import 'package:budget_tracker/features/notifications/screens/notifications_screen.dart';
import 'package:budget_tracker/features/settings/screens/settings_screen.dart';
import 'package:budget_tracker/features/transfer/screens/payment_success_screen.dart';
import 'package:budget_tracker/features/transfer/screens/transaction_register_screen.dart';
import 'package:budget_tracker/features/transfer/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/features/auth/screens/auth_screen.dart';

void navigateToAuthScreen(BuildContext context) {
  Navigator.pushNamed(
    context,
    AuthScreen.routeName,
  );
}

void navigateToNumberAccount(BuildContext context) {
  Navigator.pushNamed(
    context,
    NumberAccountScreen.routeName,
  );
}

void navigateToSettingsPage(BuildContext context) {
  Navigator.pushNamed(
    context,
    SettingsScreen.routeName,
  );
}

void navigateToNotificationsPage(BuildContext context) {
  Navigator.pushNamed(
    context,
    NotificationsScreen.routeName,
  );
}

void navigateToSearchScreen(BuildContext context) {
  Navigator.pushNamed(
    context,
    SearchScreen.routeName,
  );
}

void navigateToPaymentSuccessScreen(BuildContext context) {
  Navigator.pushReplacementNamed(
    context,
    PaymentSuccessScreen.routeName,
  );
}
