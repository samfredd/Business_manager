import 'package:business_manager/screens/home_page.dart';
import 'package:business_manager/screens/add_products_screen.dart';
import 'package:business_manager/screens/items_screen.dart';
import 'package:business_manager/screens/sales_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNav extends StatefulWidget {
  final String userId; // Add userId parameter

  const BottomNav({super.key, required this.userId});

  @override
  BottomNavState createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  // Update the list of widgets to use the provided userId
  static List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreen(userId: widget.userId),
      AddProductScreen(),
      SalesScreen(),
      ViewItemsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _widgetOptions.elementAt(_selectedIndex),
          Positioned(
            left: 0,
            right: 0,
            bottom: 1,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: SafeArea(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      const Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 8),
                          child: GNav(
                              color: Colors.white,
                              gap: 10,
                              activeColor: Colors.black,
                              iconSize: 24,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              duration: const Duration(milliseconds: 800),
                              tabBackgroundColor: Colors.white,
                              tabs: const [
                                GButton(
                                  icon: Icons.home_outlined,
                                  text: 'Home',
                                ),
                                GButton(
                                  icon: Icons.shopping_cart_checkout,
                                  text: 'Wallet',
                                ),
                                GButton(
                                  icon: Icons.compare_arrows_outlined,
                                  text: 'Transactions',
                                ),
                                GButton(
                                  icon: Icons.settings_outlined,
                                  text: 'Settings',
                                ),
                              ],
                              selectedIndex: _selectedIndex,
                              onTabChange: (index) {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
