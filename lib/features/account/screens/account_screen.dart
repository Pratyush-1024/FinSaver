import 'package:budget_tracker/features/add_card/services/add_card_services.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/features/auth/widgets/account_screen/avatar_section.dart';
import 'package:budget_tracker/features/auth/widgets/account_screen/bank_account_details_section.dart';
import 'package:budget_tracker/features/auth/widgets/account_screen/more_detail_section.dart';
import 'package:budget_tracker/providers/user_provider.dart';
import 'package:budget_tracker/features/account/services/account_services.dart';
import 'package:budget_tracker/features/notifications/service/notifications_service.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: GlobalVariables.backgroundColorGradient,
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AvatarSection(
                userName: user.name,
                defaultImagePath: 'assets/images/default_avatar.png',
              ),
              const SizedBox(height: 20),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email, color: Colors.white70),
                  const SizedBox(width: 5),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder<Map<String, String>?>(
                future: AddCardService().getUserBankDetail(context: context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    NotificationService().createNotification(
                      context: context,
                      title: 'Bank Details Error',
                      body:
                          'Failed to load bank account details. Please try again later.',
                    );
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return _buildPlaceholderContainer();
                  } else {
                    Map<String, String> userBankDetail = snapshot.data!;
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.phone, color: Colors.white70),
                            const SizedBox(width: 5),
                            Text(
                              userBankDetail['phoneNumber'] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        BankAccountDetailsSection(
                          userBankDetail: userBankDetail,
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              FutureBuilder<Map<String, String>?>(
                future: UserMoreDetailsService()
                    .getUserMoreDetails(context: context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    NotificationService().createNotification(
                      context: context,
                      title: 'User Details Error',
                      body:
                          'Failed to load user details. Please try again later.',
                    );
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return _buildPlaceholderContainer();
                  } else {
                    Map<String, String> userMoreDetails = snapshot.data!;
                    return Column(
                      children: [
                        MoreDetailsSection(userMoreDetails: userMoreDetails),
                        const SizedBox(height: 40),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderContainer() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'Data not available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
