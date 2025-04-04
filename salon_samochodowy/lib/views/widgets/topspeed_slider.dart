import 'package:flutter/material.dart';

class TopspeedSlider extends StatelessWidget {
  final double topSpeed;
  final ValueChanged<double> onChanged;

  const TopspeedSlider({
    Key? key,
    required this.topSpeed,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Maksymalna predkosc',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        Text(
          '${topSpeed.toStringAsFixed(1)} km/h',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Slider(
          min: 0,
          max: 400,
          divisions: 1000,
          label: topSpeed.toStringAsFixed(1),
          onChanged: onChanged,
          value: topSpeed,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
        ),
      ],
    );
  }
}
