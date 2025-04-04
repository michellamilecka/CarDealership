import 'package:flutter/material.dart';

class AccelerationSlider extends StatelessWidget {
  final double acceleration;
  final ValueChanged<double> onChanged;

  const AccelerationSlider({
    Key? key,
    required this.acceleration,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Przyspieszenie',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        // Zmiana, by pokazywało wartości z przecinkiem (np. 2.5 s)
        Text(
          '${acceleration.toStringAsFixed(1)} s', // 1 miejsce po przecinku
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Slider(
          min: 0,
          max: 10,
          divisions: 100,
          label: acceleration.toStringAsFixed(1),
          onChanged: onChanged,
          value: acceleration,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
        ),
      ],
    );
  }
}
