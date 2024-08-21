import 'package:flutter/material.dart';

Widget actionButton(String title, IconData icon, GestureTapCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, color: Colors.black, size: 30),
        ),
        const SizedBox(height: 6),
        Text(title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            )),
      ],
    ),
  );
}
