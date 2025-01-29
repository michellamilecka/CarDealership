import 'package:flutter/material.dart';

class CarConditionDropdown extends StatelessWidget {
  final String? selectedCondition;
  final ValueChanged<String?> onChanged;

  const CarConditionDropdown({
    Key? key,
    required this.selectedCondition,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stan samochodu', // Tekst etykiety dla stanu samochodu
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        DropdownButton<String>(
          isExpanded: true,
          value: selectedCondition,
          hint: Text("Wybierz stan",
              style: TextStyle(
                  color: Colors.grey
              ),
          ), // Tekst podpowiedzi
          onChanged: onChanged, // Callback, który zostanie wywołany przy zmianie wartości
          items: <String>[
            'Nowy', // Opcje stanu samochodu
            'Używany',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value), // Wyświetlenie każdej opcji stanu
            );
          }).toList(),
        ),
      ],
    );
  }
}
