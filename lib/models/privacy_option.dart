import 'package:flutter/material.dart';

class PrivacyOption {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  PrivacyOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
