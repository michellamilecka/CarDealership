import 'package:flutter/material.dart';
import '../widgets/new_car_widget.dart';

class UsedCarsScreen extends StatelessWidget{
  const UsedCarsScreen({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            const SizedBox(height: 16),
          ]
        //  child: NewCarsWidget(), // Wywołanie widgetu NewCarsWidget
      ),
    );
  }

}