import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewItemsScreen extends StatelessWidget {
  const ViewItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Saved Items'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('inventory').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No items found.'));
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return ListTile(
                title: Text(document['itemName']),
                subtitle: Text('Price: \$${document['itemPrice']}, Quantity: ${document['quantity']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('inventory').doc(document.id).delete();
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
