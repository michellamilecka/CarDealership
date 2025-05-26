import 'package:flutter/material.dart';

class EnginePowerSlider extends StatelessWidget {
  final double enginePower;
  final ValueChanged<double> onChanged;

  const EnginePowerSlider({
    Key? key,
    required this.enginePower,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Moc silnika',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Text(
          '${enginePower.toStringAsFixed(0)} KM',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Slider(
          min: 0,
          max: 1000,
          divisions: 100,
          label: enginePower.toStringAsFixed(0),
          onChanged: onChanged,
          value: enginePower,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
        ),
      ],
    );
  }
}
