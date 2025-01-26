import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:salon_samochodowy/views/screens/new_cars_screen.dart';

class NewCarsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(),
      child: Column(
          children: [
        Container(
          child: Iconify(
            Ph.car_simple_bold,
            size: 96,
          ),
        ),
        Text(
          'Nowe samochody',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewCarsScreen(title: 'New Cars')));
            },
              style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Set the radius here
              ),
            ),
            child: Text(
              'Wyszukaj',
            ))
      ]),
    );
  }
}
