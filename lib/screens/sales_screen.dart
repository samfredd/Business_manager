import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  SalesScreenState createState() => SalesScreenState();
}

class SalesScreenState extends State<SalesScreen> {
  final TextEditingController itemIdController = TextEditingController();
  final TextEditingController quantitySoldController = TextEditingController();

  Future<void> recordSale() async {
    String itemId = itemIdController.text;
    int quantitySold = int.parse(quantitySoldController.text);

    DocumentReference itemRef = FirebaseFirestore.instance.collection('inventory').doc(itemId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(itemRef);
      int newQuantity = snapshot['quantity'] - quantitySold;

      if (newQuantity >= 0) {
        transaction.update(itemRef, {'quantity': newQuantity});
        await FirebaseFirestore.instance.collection('sales').add({
          'itemId': itemId,
          'quantitySold': quantitySold,
          'date': FieldValue.serverTimestamp(),
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough stock')));
      }
    });

    itemIdController.clear();
    quantitySoldController.clear();
  }

  @override
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            // Go back to the previous screen
          },
        ),
        title: const Text(
          'Record a sale',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Save action
            },
            child: const Text('Save', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Order Date',
                  hintText: '16/08/2024',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Select Customer (optional)',
                  suffixIcon: Icon(Icons.arrow_forward_ios),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Leave blank if you don’t have customer’s contact information',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Sales Channel',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildSalesChannelTile('Physical sales', Icons.store, Colors.green),
                  _buildSalesChannelTile('Instagram', Icons.camera_alt, Colors.grey),
                  _buildSalesChannelTile('WhatsApp', Icons.message, Colors.grey),
                  _buildSalesChannelTile('Facebook', Icons.facebook, Colors.grey),
                  _buildSalesChannelTile('Tiktok', Icons.music_note, Colors.grey),
                  _buildSalesChannelTile('Jumia', Icons.shopping_cart, Colors.grey),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Products', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          // Add new product
                        },
                        child: const Text('New Product', style: TextStyle(color: Colors.green)),
                      ),
                      TextButton(
                        onPressed: () {
                          // Select existing product
                        },
                        child: const Text('Select Products', style: TextStyle(color: Colors.green)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Payment Status',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPaymentStatusButton('UNPAID', true),
                  const SizedBox(width: 8),
                  _buildPaymentStatusButton('PAID', false),
                  const SizedBox(width: 8),
                  _buildPaymentStatusButton('PARTIALLY PAID', false),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Record the sale
                  },
                  child: const Text('Record sale'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalesChannelTile(String label, IconData icon, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildPaymentStatusButton(String label, bool selected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.green.withOpacity(0.1) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? Colors.green : Colors.grey),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.green : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Record Sale')),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           TextField(
  //             controller: itemIdController,
  //             decoration: const InputDecoration(labelText: 'Item ID'),
  //           ),
  //           TextField(
  //             controller: quantitySoldController,
  //             decoration: const InputDecoration(labelText: 'Quantity Sold'),
  //             keyboardType: TextInputType.number,
  //           ),
  //           const SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: recordSale,
  //             child: const Text('Record Sale'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

