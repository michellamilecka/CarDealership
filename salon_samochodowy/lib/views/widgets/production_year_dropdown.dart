import 'package:flutter/material.dart';

class ProductionYearDropdown extends StatelessWidget {
  final int? selectedYear;
  final ValueChanged<int> onChanged;
  final List<int> years;

  const ProductionYearDropdown({
    Key? key,
    required this.selectedYear,
    required this.onChanged,
    required this.years,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rok produkcji',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Container(
          width: 200,
          child: DropdownButton<int>(
            value: selectedYear,
            onChanged: (int? newYear) {
              if (newYear != null) {
                onChanged(newYear);
              }
            },
            items: years.map<DropdownMenuItem<int>>((int year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text(year.toString()),
              );
            }).toList(),
            hint: Text("Wybierz rok"),
            isExpanded: true,
            isDense: true,
            dropdownColor: Colors.white,
            itemHeight: 48,
          ),
        ),
      ],
    );
  }
}
