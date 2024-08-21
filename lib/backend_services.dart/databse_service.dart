  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();


Future<void> addItem() async {
    await FirebaseFirestore.instance.collection('inventory').add({
      'itemName': nameController.text,
      'itemPrice': double.parse(priceController.text),
      'quantity': int.parse(quantityController.text),
    });
    nameController.clear();
    priceController.clear();
    quantityController.clear();
  }