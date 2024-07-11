import 'package:budget_tracker/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.left_chevron),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Language'),
      ),
      body: ListView(
        children: [
          _buildLanguageOption(
            context: context,
            language: 'English',
            locale: const Locale('en'),
          ),
          _buildLanguageOption(
            context: context,
            language: 'हिन्दी (Hindi)',
            locale: const Locale('hi'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String language,
    required Locale locale,
  }) {
    return ListTile(
      title: Text(language),
      onTap: () {
        Provider.of<LanguageProvider>(context, listen: false).setLocale(locale);
      },
    );
  }
}
