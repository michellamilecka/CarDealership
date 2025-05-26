import 'package:flutter/material.dart';

class BodyTypeDropdown extends StatelessWidget {
  final String? selectedBodyType;
  final ValueChanged<String?> onChanged;

  const BodyTypeDropdown({
    Key? key,
    required this.selectedBodyType,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rodzaj nadwozia',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        DropdownButton<String>(
          isExpanded: true,
          value: selectedBodyType,
          hint: Text("Wybierz nadwozie",
              style: TextStyle(
                  color: Colors.grey
              )
          ),
          onChanged: onChanged,
          items: <String>[
            'suv',
            'compact',
            'cabriolet',
            'combi',
            'limuzyna',
            'coupe'
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
