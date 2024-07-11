import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/features/add_card/services/add_card_services.dart';
import 'package:budget_tracker/features/auth/widgets/bank_card_screen/details_widget.dart';
import 'package:budget_tracker/features/auth/widgets/bank_card_screen/option_list.dart';
import 'package:budget_tracker/features/transfer/services/transation_services.dart';
import 'package:budget_tracker/models/transations.dart';
import 'package:flutter/material.dart';

class BankCardScreen extends StatefulWidget {
  const BankCardScreen({super.key});

  @override
  State<BankCardScreen> createState() => _BankCardScreenState();
}

class _BankCardScreenState extends State<BankCardScreen> {
  List<Transaction> _recentTransactions = [];
  String _selectedOption = '';
  Map<String, String> _userBankDetails = {};

  @override
  void initState() {
    super.initState();
    _fetchUserBankDetails();
    _fetchRecentTransactions();
  }

  Future<void> _fetchUserBankDetails() async {
    final addCardService = AddCardService();
    final userBankDetails =
        await addCardService.getUserBankDetail(context: context);

    if (userBankDetails != null) {
      setState(() {
        _userBankDetails = userBankDetails;
      });
    }
  }

  Future<void> _fetchRecentTransactions() async {
    final transactionService = TransactionService();
    final recentTransactions =
        await transactionService.getRecentTransactions(context);

    setState(() {
      _recentTransactions = recentTransactions;
    });
  }

  String _censorAccountNumber(String accountNumber) {
    if (accountNumber.length > 4) {
      return accountNumber.replaceRange(
          0, accountNumber.length - 4, '*' * (accountNumber.length - 4));
    }
    return accountNumber;
  }

  @override
  Widget build(BuildContext context) {
    String accountNumber = _userBankDetails['accountNumber'] ?? '';
    String accountName = _userBankDetails['accountName'] ?? 'Your Account Name';
    String accountCreation = _userBankDetails['updatedAt'] ?? 'DDMMYYYY';

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: GlobalVariables.backgroundColorGradient,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 350,
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.only(
                    top: 40.0,
                    right: 35.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        GlobalVariables.primaryColor,
                        GlobalVariables.selectedNavBarColor,
                      ],
                      stops: const [0.5, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 11, 9, 39)
                            .withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _censorAccountNumber(accountNumber),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Set text color to white
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 50.0,
                          ),
                          child: const Text(
                            'Bank',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        OptionsList(
                          selectedOption: _selectedOption,
                          onOptionSelected: (title) {
                            setState(() {
                              _selectedOption = title;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 70, left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailsWidget(
                        selectedOption: _selectedOption,
                        accountName: accountName,
                        accountNumber: accountNumber,
                        accountCreation: accountCreation,
                        recentTransactions: _recentTransactions,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
