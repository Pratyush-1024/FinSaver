// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:budget_tracker/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:budget_tracker/models/user.dart';
import 'package:budget_tracker/features/auth/services/auth_service.dart';
import 'package:budget_tracker/features/transfer/screens/transaction_register_screen.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  List<User> _searchResults = [];

  bool _isLoading = false;

  String generateProfileImageUrl(String userName) {
    return 'https://robohash.org/$userName.png?set=set4';
  }

  void searchUsers() async {
    if (_searchController.text.isNotEmpty) {
      List<User> results =
          await _authService.searchUsersByName(_searchController.text, context);
      setState(() {
        _searchResults = results;
      });
    }
  }

  void navigateToNumberAccountScreen(User user) async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NumberAccountScreen(
          profileImageUrl: generateProfileImageUrl(user.name),
          userName: user.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: GlobalVariables.appBarGradient,
          ),
        ),
        leading: CupertinoNavigationBarBackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Search Users'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: GlobalVariables.backgroundColorGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by username',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: searchUsers,
                  ),
                ),
                onChanged: (val) {
                  searchUsers();
                },
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final user = _searchResults[index];
                          String profileImageUrl =
                              generateProfileImageUrl(user.name);
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(profileImageUrl),
                            ),
                            title: Text(user.name),
                            subtitle: Text(user.email),
                            onTap: () => navigateToNumberAccountScreen(user),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
