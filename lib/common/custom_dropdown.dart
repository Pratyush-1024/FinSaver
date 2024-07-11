import 'package:flutter/material.dart';

class DropdownLogic {
  static const List<String> options = ['Income', 'Expense'];
  String dropdownValue = options[0]; // Default value for dropdown

  DropdownButton<String> buildDropdownButton(Function(String) onChanged) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      underline: const SizedBox(), // Removes the default underline
      onChanged: (String? newValue) {
        dropdownValue = newValue!;
        onChanged(newValue);
      },
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
