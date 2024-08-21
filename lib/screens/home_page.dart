import 'package:business_manager/backend_services.dart/auth_service.dart';
import 'package:business_manager/screens/items_screen.dart';
import 'package:flutter/material.dart';
import 'package:business_manager/widgets/action_button.dart';
import 'package:business_manager/widgets/app_bar.dart';
import 'package:business_manager/widgets/status_card.dart';
import 'package:business_manager/widgets/updates_card.dart';
import 'add_products_screen.dart';
import 'sales_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userId; // Use user ID to fetch data from Firestore

  const HomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    String getGreeting() {
      final hour = DateTime.now().hour;

      if (hour < 12) {
        return 'Good Morning';
      } else if (hour < 17) {
        return 'Good Afternoon';
      } else {
        return 'Good Evening';
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppAppBar(
        centerTitle: false,
        title: FutureBuilder<String>(
          future: fetchUsername(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                strokeWidth: BorderSide.strokeAlignCenter,
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              String greeting =
                  getGreeting(); // Get the appropriate greeting based on the time of day
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: const TextStyle(color: Colors.black, fontSize: 24),
                  ),
                  Text(
                    "${snapshot.data}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }
          },
        ),
        height: 100,
        trailing: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
              size: 48,
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(34),
            topLeft: Radius.circular(34),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Text(
                                'Total Sales:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                '₦0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final statusCards = [
                          statusCard('Orders', '0', Colors.green, () {}),
                          statusCard('Products sold', '0', Colors.blue, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SalesScreen(),
                              ),
                            );
                          }),
                          statusCard(
                              'Pending Orders', '0', Colors.yellow, () {}),
                          statusCard('Stock', '0', Colors.red, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ViewItemsScreen(),
                              ),
                            );
                          }),
                        ];
                        return statusCards[index];
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        actionButton(
                          'Create Order',
                          Icons.shopping_cart,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SalesScreen(),
                              ),
                            );
                          },
                        ),
                        actionButton(
                          'New Product',
                          Icons.add,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddProductScreen(),
                              ),
                            );
                          },
                        ),
                        actionButton(
                          'Sales',
                          Icons.trending_up,
                          () {},
                        ),
                        actionButton(
                          'Get Support',
                          Icons.support_agent,
                          () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Latest news',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    updatesCard(
                        'New Subscription Updates', 'Aug, 08', 'Features'),
                    updatesCard('Letters from the CEO\'s Desk', 'Aug, 06',
                        'Entertainment'),
                    updatesCard(
                        'New Subscription Updates', 'Aug, 08', 'Features'),
                    updatesCard('Letters from the CEO\'s Desk', 'Aug, 06',
                        'Entertainment'),
                    updatesCard(
                        'New Subscription Updates', 'Aug, 08', 'Features'),
                    updatesCard('Letters from the CEO\'s Desk', 'Aug, 06',
                        'Entertainment'),
                    updatesCard(
                        'New Subscription Updates', 'Aug, 08', 'Features'),
                    updatesCard('Letters from the CEO\'s Desk', 'Aug, 06',
                        'Entertainment'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
