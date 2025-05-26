import 'package:flutter/material.dart';

class DriveTypeDropdown extends StatelessWidget {
  final String? selectedDriveType;
  final ValueChanged<String?> onChanged;

  const DriveTypeDropdown({
    Key? key,
    required this.selectedDriveType,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rodzaj napędu',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        DropdownButton<String>(
          isExpanded: true,
          value: selectedDriveType,
          hint: Text("Wybierz napęd",
              style: TextStyle(
                  color: Colors.grey
              ),
          ),
          onChanged: onChanged,
          items: <String>[
            'Napęd tylny',
            'Napęd przedni',
            'na wszystkie koła'
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
