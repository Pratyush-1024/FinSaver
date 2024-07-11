import 'package:budget_tracker/features/add_card/screens/add_card_screen.dart';
import 'package:budget_tracker/features/add_details/screens/add_details.dart';
import 'package:budget_tracker/features/auth/screens/auth_screen.dart';
import 'package:budget_tracker/features/auth/screens/get_started_screen.dart';
import 'package:budget_tracker/features/home/screens/home_screen.dart';
import 'package:budget_tracker/features/auth/widgets/bottom_bar.dart';
import 'package:budget_tracker/features/settings/screens/settings_screen.dart';
import 'package:budget_tracker/features/transfer/screens/payment_success_screen.dart';
import 'package:budget_tracker/features/transfer/screens/transaction_register_screen.dart';
import 'package:budget_tracker/features/transfer/screens/search_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );

    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );

    case GetStartedScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const GetStartedScreen(),
      );

    case AddCard.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddCard(),
      );

    case AddDetails.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddDetails(),
      );

    case NumberAccountScreen.routeName:
      final args = routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => NumberAccountScreen(
          profileImageUrl: args['profileImageUrl'],
          userName: args['userName'],
        ),
      );

    case SettingsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SettingsScreen(),
      );

    case SearchScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SearchScreen(),
      );

    case PaymentSuccessScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PaymentSuccessScreen(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist'),
          ),
        ),
      );
  }
}
