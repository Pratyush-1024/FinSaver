import 'package:flutter/material.dart';

class OptionsList extends StatelessWidget {
  final String selectedOption;
  final Function(String) onOptionSelected;

  const OptionsList({
    required this.selectedOption,
    required this.onOptionSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOption('Your Balance'),
        const SizedBox(height: 20),
        _buildOption('Transaction History'),
        const SizedBox(height: 20),
        _buildOption('Your Account'),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildOption(String title) {
    final isSelected = selectedOption == title;
    return GestureDetector(
      onTap: () {
        onOptionSelected(title);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Colors.grey.withOpacity(0.4),
                    Colors.grey.withOpacity(0.01),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.02),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
