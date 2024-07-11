import 'package:flutter/material.dart';
import 'package:budget_tracker/features/auth/widgets/account_screen/bank_form_widget.dart';
import 'package:budget_tracker/features/add_card/services/add_card_services.dart';

class BankAccountDetailsSection extends StatefulWidget {
  final Map<String, String> userBankDetail;

  const BankAccountDetailsSection({
    super.key,
    required this.userBankDetail,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BankAccountDetailsSectionState createState() =>
      _BankAccountDetailsSectionState();
}

class _BankAccountDetailsSectionState extends State<BankAccountDetailsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxWidth: 400,
        minWidth: 350,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bank Account Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Account Name: ${widget.userBankDetail['accountName'] ?? 'N/A'}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Account Number: ${widget.userBankDetail['accountNumber'] ?? 'N/A'}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Phone Number: ${widget.userBankDetail['phoneNumber'] ?? 'N/A'}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white70,
                ),
                onPressed: () {
                  _showUpdateBankDetailsForm(context, widget.userBankDetail);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUpdateBankDetailsForm(
    BuildContext context,
    Map<String, String> initialDetails,
  ) async {
    await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return UpdateBankAccountDetailsForm(
          initialDetails: initialDetails,
          onSave: (updatedDetails) {
            AddCardService().updateUserBankDetails(
              context: context,
              accountName: updatedDetails['accountName']!,
              accountNumber: updatedDetails['accountNumber']!,
              phoneNumber: updatedDetails['phoneNumber']!,
            );
            setState(() {
              widget.userBankDetail.addAll(updatedDetails);
            });
          },
        );
      },
    );
  }
}
