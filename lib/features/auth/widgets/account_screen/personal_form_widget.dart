// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class UpdateMoreDetailsForm extends StatefulWidget {
  final Map<String, String> initialDetails;
  final Function(Map<String, String>) onSave;

  const UpdateMoreDetailsForm({
    super.key,
    required this.initialDetails,
    required this.onSave,
  });

  @override
  _UpdateMoreDetailsFormState createState() => _UpdateMoreDetailsFormState();
}

class _UpdateMoreDetailsFormState extends State<UpdateMoreDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late String _address;
  late String _bio;

  @override
  void initState() {
    super.initState();
    _address = widget.initialDetails['address'] ?? '';
    _bio = widget.initialDetails['bio'] ?? '';
  }

  void _saveDetails() {
    if (_formKey.currentState!.validate()) {
      widget.onSave({
        'address': _address,
        'bio': _bio,
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update More Details'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _address,
              decoration: const InputDecoration(labelText: 'Address'),
              onChanged: (value) => setState(() => _address = value),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: _bio,
              decoration: const InputDecoration(labelText: 'Bio'),
              onChanged: (value) => setState(() => _bio = value),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your bio';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveDetails,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
