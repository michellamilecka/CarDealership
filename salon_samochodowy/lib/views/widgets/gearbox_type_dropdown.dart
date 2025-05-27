import 'package:flutter/material.dart';

class GearboxTypeDropdown extends StatelessWidget {
  final String? selectedGearbox;
  final ValueChanged<String?> onChanged;

  const GearboxTypeDropdown({
    Key? key,
    required this.selectedGearbox,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skrzynia biegów',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        DropdownButton<String>(
          isExpanded: true,
          value: selectedGearbox,
          hint: Text("Wybierz skrzynię biegów",
          style: TextStyle(
              color: Colors.grey
          )
          ),
          onChanged: onChanged,
          items: <String>['7-stopniowa, automatyczna', '1-stopniowa, automatyczna', '8-stopniowa, automatyczna','6-biegowa skrzynia manualna']
              .map<DropdownMenuItem<String>>((String value) {
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
