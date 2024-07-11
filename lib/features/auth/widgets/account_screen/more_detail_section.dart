// ignore_for_file: library_private_types_in_public_api

import 'package:budget_tracker/features/account/services/account_services.dart';
import 'package:budget_tracker/features/auth/widgets/account_screen/personal_form_widget.dart';
import 'package:flutter/material.dart';

class MoreDetailsSection extends StatefulWidget {
  final Map<String, String> userMoreDetails;

  const MoreDetailsSection({
    super.key,
    required this.userMoreDetails,
  });

  @override
  _MoreDetailsSectionState createState() => _MoreDetailsSectionState();
}

class _MoreDetailsSectionState extends State<MoreDetailsSection> {
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
            'More Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Address: ${widget.userMoreDetails['address'] ?? 'N/A'}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Member Since: ${widget.userMoreDetails['memberSince'] ?? 'N/A'}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Bio: ${widget.userMoreDetails['bio'] ?? 'N/A'}',
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
                  _showUpdateMoreDetailsForm(context, widget.userMoreDetails);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUpdateMoreDetailsForm(
    BuildContext context,
    Map<String, String> initialDetails,
  ) async {
    final updatedDetails = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return UpdateMoreDetailsForm(
          initialDetails: initialDetails,
          onSave: (updatedDetails) {
            UserMoreDetailsService().updateUserMoreDetails(
              context: context,
              address: updatedDetails['address']!,
              bio: updatedDetails['bio']!,
            );
            setState(() {
              widget.userMoreDetails.addAll(updatedDetails);
            });
          },
        );
      },
    );

    if (updatedDetails != null) {
      setState(() {
        widget.userMoreDetails.addAll(updatedDetails);
      });
    }
  }
}
