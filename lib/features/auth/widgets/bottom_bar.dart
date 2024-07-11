import 'package:budget_tracker/features/account/screens/account_screen.dart';
import 'package:budget_tracker/features/bank_card/screen/bank_card_screen.dart';
import 'package:budget_tracker/features/transfer/screens/transfer_screen.dart';
import 'package:budget_tracker/docs/screens/docs_screen.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/constants/global_variables.dart';
import 'package:budget_tracker/features/home/screens/home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  static const String routeName = '/actual-route';

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;

  List<Widget> pages = [
    const HomeScreen(),
    const TransferScreen(),
    const DocumentScreen(),
    const BankCardScreen(),
    const AccountScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[_page],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 70,
              decoration: const BoxDecoration(
                color: GlobalVariables.bottomBarBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28.0),
                  topRight: Radius.circular(28.0),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _page,
                onTap: updatePage,
                selectedItemColor: Colors.white,
                unselectedItemColor: GlobalVariables.unselectedNavBarColor,
                backgroundColor: Colors.transparent,
                iconSize: 28,
                type: BottomNavigationBarType.fixed,
                elevation: 0.0,
                selectedIconTheme:
                    const IconThemeData(color: Colors.white, size: 28),
                unselectedIconTheme:
                    const IconThemeData(color: Colors.white, size: 28),
                selectedFontSize: 12.0,
                unselectedFontSize: 12.0,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      FontAwesomeIcons.houseUser,
                      color: _page == 0
                          ? Colors.white
                          : GlobalVariables.unselectedNavBarColor,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      FontAwesomeIcons.rightLeft,
                      color: _page == 1
                          ? Colors.white
                          : GlobalVariables.unselectedNavBarColor,
                    ),
                    label: 'Transaction',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.all(14.5),
                      child: Container(),
                    ),
                    label: 'Vault',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      FontAwesomeIcons.buildingColumns,
                      color: _page == 3
                          ? Colors.white
                          : GlobalVariables.unselectedNavBarColor,
                    ),
                    label: 'Bank',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      FontAwesomeIcons.userGraduate,
                      color: _page == 4
                          ? Colors.white
                          : GlobalVariables.unselectedNavBarColor,
                    ),
                    label: 'Account',
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 35,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: FloatingActionButton(
              onPressed: () {
                updatePage(2);
              },
              backgroundColor: GlobalVariables.selectedNavBarColor,
              heroTag: null,
              child: const Icon(FontAwesomeIcons.vault,
                  size: 32, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
