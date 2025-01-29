import 'package:flutter/material.dart';

class PriceSlider extends StatelessWidget {
  final double price;
  final ValueChanged<double> onChanged;

  const PriceSlider({
    Key? key,
    required this.price,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cena',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          '${price.toStringAsFixed(0)} PLN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Slider(
          min: 0,
          max: 2000000,
          divisions: 100,
          label: price.toStringAsFixed(0),
          onChanged: onChanged,
          value: price,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
        ),
      ],
    );
  }
}
