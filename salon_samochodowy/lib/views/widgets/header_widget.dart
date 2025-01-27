import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/simple_icons.dart';
class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "BMW",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 400,
                height: 1, // Grubość linii
                color: Colors.white, // Kolor linii
              ),
            ],
          ),
          actions: [
            Iconify(
              SimpleIcons.bmw,
              color: Colors.white,
              size: 36,
            ),
            const SizedBox(width: 6),
          ],
        )
    );
  }
}
