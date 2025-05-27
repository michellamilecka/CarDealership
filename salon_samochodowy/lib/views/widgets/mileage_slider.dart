import 'package:flutter/material.dart';

class MileageSlider extends StatelessWidget {
  final double mileage;
  final ValueChanged<double> onChanged;

  const MileageSlider({
    Key? key,
    required this.mileage,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Przebieg',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        Text(
          '${mileage.toStringAsFixed(1)} km',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Slider(
          min: 0,
          max: 50000,
          divisions: 100,
          label: mileage.toStringAsFixed(1),
          onChanged: onChanged,
          value: mileage,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
        ),
      ],
    );
  }
}
