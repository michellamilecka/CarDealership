import 'package:flutter/material.dart';

class GasmileageSlider extends StatelessWidget {
  final double gasMileage;
  final ValueChanged<double> onChanged;

  const GasmileageSlider({
    Key? key,
    required this.gasMileage,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Zużycie paliwa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        Text(
          '${gasMileage.toStringAsFixed(1)} l',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Slider(
          min: 0,
          max: 20,
          divisions: 100,
          label: gasMileage.toStringAsFixed(1),
          onChanged: onChanged,
          value: gasMileage,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
        ),
      ],
    );
  }
}
