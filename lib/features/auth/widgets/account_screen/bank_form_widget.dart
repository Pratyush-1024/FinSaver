import 'package:flutter/material.dart';

class UpdateBankAccountDetailsForm extends StatefulWidget {
  final Map<String, String> initialDetails;
  final Function(Map<String, String>) onSave;

  const UpdateBankAccountDetailsForm({
    super.key,
    required this.initialDetails,
    required this.onSave,
  });

  @override
  // ignore: library_private_types_in_public_api
  _UpdateBankAccountDetailsFormState createState() =>
      _UpdateBankAccountDetailsFormState();
}

class _UpdateBankAccountDetailsFormState
    extends State<UpdateBankAccountDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late String _accountName;
  late String _accountNumber;
  late String _phoneNumber;

  @override
  void initState() {
    super.initState();
    _accountName = widget.initialDetails['accountName'] ?? '';
    _accountNumber = widget.initialDetails['accountNumber'] ?? '';
    _phoneNumber = widget.initialDetails['phoneNumber'] ?? '';
  }

  void _saveDetails() {
    if (_formKey.currentState!.validate()) {
      widget.onSave({
        'accountName': _accountName,
        'accountNumber': _accountNumber,
        'phoneNumber': _phoneNumber,
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Bank Account Details'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _accountName,
              decoration: const InputDecoration(labelText: 'Account Name'),
              onChanged: (value) => setState(() => _accountName = value),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter account name';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: _accountNumber,
              decoration: const InputDecoration(labelText: 'Account Number'),
              onChanged: (value) => setState(() => _accountNumber = value),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter account number';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: _phoneNumber,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              onChanged: (value) => setState(() => _phoneNumber = value),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter phone number';
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
