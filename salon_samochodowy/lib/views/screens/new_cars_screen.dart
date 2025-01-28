import 'package:flutter/material.dart';
import '../widgets/new_car_widget.dart';

class NewCarsScreen extends StatelessWidget{
  const NewCarsScreen({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nowe Samochody")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Filtry',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Model i Rodzaj nadwozia w jednej linii
            Row(
              children: [
                // Model
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Model',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        hint: Text("Wybierz model"),
                        onChanged: (String? newValue) {},
                        items: <String>['M3', 'M4', 'M5', 'M6']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Rodzaj nadwozia
                Expanded(
                  child: Column(
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
                        hint: Text("Wybierz nadwozie"),
                        onChanged: (String? newValue) {},
                        items: <String>[
                          'Limuzyna', 'Touring', 'Cabrio', 'Coupé', 'Sports Activity Coupé', 'Sports Activity Vehicle', 'Hatch', 'Tourer', 'BMW i', 'Gran Coupé'
                        ]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Rodzaj napędu i Rodzaj paliwa w jednej linii
            Row(
              children: [
                // Rodzaj napędu
                Expanded(
                  child: Column(
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
                        hint: Text("Wybierz napęd"),
                        onChanged: (String? newValue) {},
                        items: <String>['tylnie koła', 'przednie koła', 'xDrive']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Rodzaj paliwa
                Expanded(
                  child: Column(
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
                        hint: Text("Wybierz paliwo"),
                        onChanged: (String? newValue) {},
                        items: <String>['Diesel', 'Benzyna', 'Plug-in']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Skrzynia biegów i Moc silnika w jednej linii
            Row(
              children: [
                // Skrzynia biegów
                Expanded(
                  child: Column(
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
                        hint: Text("Wybierz skrzynię biegów"),
                        onChanged: (String? newValue) {},
                        items: <String>['Manual', 'Steptronic', '7-DKG']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Moc silnika
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Moc silnika',
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
                        label: "0",
                        onChanged: (double value) {},
                        value: 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cena
            Text(
              'Cena',
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
              label: "0",
              onChanged: (double value) {},
              value: 0,
            ),
            const SizedBox(height: 16),

            // Przycisk "Wyszukaj"
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Tutaj dodaj logikę do obsługi wyszukiwania
                },
                child: Text(
                  'Wyszukaj',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}