import 'package:flutter/material.dart';
import '../widgets/footer_widget.dart';

class NewCarsScreen extends StatelessWidget{
  const NewCarsScreen({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'New Cars', // Wyświetlany tekst
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            ElevatedButton(
                onPressed:() {
                Navigator.pop(context);
                },
                child: Text(
              'Go to Home', // Tekst na przycisku
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ), )
          ]
      ),
      bottomNavigationBar: FooterWidget(),
    );
  }

}