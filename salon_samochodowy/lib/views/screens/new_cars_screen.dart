import 'package:flutter/material.dart';
import '../widgets/new_car_widget.dart';

class NewCarsScreen extends StatefulWidget {
  const NewCarsScreen({super.key, required String title});

  @override
  _NewCarsScreenState createState() => _NewCarsScreenState();
}

class _NewCarsScreenState extends State<NewCarsScreen> {
  String? selectedModel;
  String? selectedBodyType;
  String? selectedDriveType;
  String? selectedFuelType;
  String? selectedGearbox;
  double enginePower = 0;
  double price = 0;

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
            // ExpansionTile for filters
            ExpansionTile(
              title: Text(
                'Filtry',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              children: [
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
                            value: selectedModel,
                            hint: Text("Wybierz model"),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedModel = newValue;
                              });
                            },
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
                            value: selectedBodyType,
                            hint: Text("Wybierz nadwozie"),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedBodyType = newValue;
                              });
                            },
                            items: <String>[
                              'Limuzyna',
                              'Touring',
                              'Cabrio',
                              'Coupé',
                              'Sports Activity Coupé',
                              'Sports Activity Vehicle',
                              'Hatch',
                              'Tourer',
                              'BMW i',
                              'Gran Coupé'
                            ].map<DropdownMenuItem<String>>((String value) {
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
                            value: selectedDriveType,
                            hint: Text("Wybierz napęd"),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDriveType = newValue;
                              });
                            },
                            items: <String>[
                              'tylnie koła',
                              'przednie koła',
                              'xDrive'
                            ].map<DropdownMenuItem<String>>((String value) {
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
                            value: selectedFuelType,
                            hint: Text("Wybierz paliwo"),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedFuelType = newValue;
                              });
                            },
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
                            value: selectedGearbox,
                            hint: Text("Wybierz skrzynię biegów"),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGearbox = newValue;
                              });
                            },
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
                            onChanged: (double value) {
                              setState(() {
                                enginePower = value;
                              });
                            },
                            value: enginePower,
                            activeColor: Colors.blue,
                            inactiveColor: Colors.grey,
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
                  onChanged: (double value) {
                    setState(() {
                      price = value;
                    });
                  },
                  value: price,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                ),
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
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Center(
                child: Container(
                  width:350,
                  height:100,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:10.0,right:100.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                        child:Image.asset('assets/auto1.png',
                            height:70,
                          fit: BoxFit.cover,),
                      ),
                      ),
                         Padding(
                          padding: const EdgeInsets.only(left:5.0),
                          child: Text(
                            'BMW iX3',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),


                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Center(
                child: Container(
                  width:350,
                  height:100,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:10.0,right:100.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child:Image.asset('assets/auto2.png',
                            height:70,
                            fit: BoxFit.cover,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Text(
                          'BMW X1',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Center(
                child: Container(
                  width:350,
                  height:100,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:10.0,right:100.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child:Image.asset('assets/auto3.png',
                            height:70,
                            fit: BoxFit.cover,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Text(
                          'BMW X6',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),


                    ],
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
