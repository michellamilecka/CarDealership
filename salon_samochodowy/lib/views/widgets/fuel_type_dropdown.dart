import 'package:flutter/material.dart';

class FuelTypeDropdown extends StatelessWidget {
  final String? selectedFuelType;
  final ValueChanged<String?> onChanged;

  const FuelTypeDropdown({
    Key? key,
    required this.selectedFuelType,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rodzaj paliwa',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        DropdownButton<String>(
          isExpanded: true,
          value: selectedFuelType,
          hint: Text("Wybierz paliwo",
              style: TextStyle(
                  color: Colors.grey
              ),
          ),
          onChanged: onChanged,
          items: <String>[
            'Diesel',
            'Benzyna',
            'Plug-in'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
