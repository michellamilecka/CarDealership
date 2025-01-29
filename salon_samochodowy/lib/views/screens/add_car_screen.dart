import 'package:flutter/material.dart';
import 'package:salon_samochodowy/views/widgets/body_type_dropdown.dart';

import '../widgets/add_photo_widget.dart';
import '../widgets/car_condition_dropdown.dart';
import '../widgets/drive_type_dropdown.dart';
import '../widgets/footer_widget.dart';
import '../widgets/fuel_type_dropdown.dart';
import '../widgets/gearbox_type_dropdown.dart';
import '../widgets/header_widget.dart';

class ChangeStateScreen extends StatefulWidget {
  const ChangeStateScreen({super.key, required String title});

  @override
  _ChangeStateScreenState createState() => _ChangeStateScreenState();
}

class _ChangeStateScreenState extends State<ChangeStateScreen> {
  String? selectedCondition; // Stan samochodu (Nowy/Używany)
  String? selectedBodyType;
  String? selectedDriveType;
  String? selectedFuelType;
  String? selectedGearbox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: HeaderWidget(),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddPhotoWidget(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      cursorColor: Color(0xFF00A8E8),
                      decoration: InputDecoration(
                        labelText: 'Model samochodu',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: 'Wpisz model',
                        floatingLabelStyle: TextStyle(
                          color: Color(0xFF00A8E8),
                          fontWeight: FontWeight.bold,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CarConditionDropdown(
                      selectedCondition: selectedCondition,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCondition = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: BodyTypeDropdown(
                      selectedBodyType: selectedBodyType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBodyType = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),


            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // Rodzaj napędu
                Expanded(
                  child: DriveTypeDropdown(
                    selectedDriveType: selectedDriveType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDriveType = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                // Rodzaj paliwa
                Expanded(
                  child: FuelTypeDropdown(
                    selectedFuelType: selectedFuelType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFuelType = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: GearboxTypeDropdown(
                      selectedGearbox: selectedGearbox,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedGearbox = newValue;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      cursorColor: Color(0xFF00A8E8),
                      decoration: InputDecoration(
                        labelText: 'Kolor',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: 'Wpisz kolor',
                        floatingLabelStyle: TextStyle(
                          color: Color(0xFF00A8E8),
                          fontWeight: FontWeight.bold,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),















            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: TextField(
                cursorColor: Color(0xFF00A8E8),
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Opis',
                  labelStyle: TextStyle(color: Colors.grey),
                  hintText: 'Opis samochodu',
                  floatingLabelStyle: TextStyle(
                    color: Color(0xFF00A8E8),
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),

            SizedBox(
              width: 150,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        'Dodano nowy samochód!',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            overlayColor: Color(0xFF00A8E8),
                          ),
                          child: Text(
                            'OK',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xD9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(65),
                  ),
                  overlayColor: Color(0xFF00A8E8),
                ),
                child: Text(
                  'Zapisz',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterWidget(),
    );
  }
}
