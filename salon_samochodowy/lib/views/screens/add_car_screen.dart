import 'package:flutter/material.dart';
import 'package:salon_samochodowy/views/widgets/body_type_dropdown.dart';

import '../widgets/add_photo_widget.dart';
import '../widgets/car_condition_dropdown.dart';
import '../widgets/drive_type_dropdown.dart';
import '../widgets/engine_power_slider.dart';
import '../widgets/footer_widget.dart';
import '../widgets/fuel_type_dropdown.dart';
import '../widgets/gearbox_type_dropdown.dart';
import '../widgets/header_widget.dart';
import '../widgets/price_slider.dart';

class ChangeStateScreen extends StatefulWidget {
  const ChangeStateScreen({super.key, required String title});

  @override
  _ChangeStateScreenState createState() => _ChangeStateScreenState();
}

class _ChangeStateScreenState extends State<ChangeStateScreen> {
  String? selectedCondition;
  String? selectedBodyType;
  String? selectedDriveType;
  String? selectedFuelType;
  String? selectedGearbox;
  double enginePower = 0;
  double price = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: HeaderWidget(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddPhotoWidget(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          cursorColor: Color(0xFF00A8E8),
                          decoration: InputDecoration(
                            labelText: 'Model samochodu',
                            labelStyle: TextStyle(color: Colors.grey),
                            hintText: 'Wpisz model',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32), // Odstęp między model a kolor
                        TextField(
                          cursorColor: Color(0xFF00A8E8),
                          decoration: InputDecoration(
                            labelText: 'Kolor',
                            labelStyle: TextStyle(color: Colors.grey),
                            hintText: 'Wpisz kolor',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
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
              const SizedBox(height: 16),
              Row(
                children: [
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
              const SizedBox(height: 16),
              Row(
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
                        labelText: 'Przebieg',
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: 'Wpisz przebieg (Km)',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: EnginePowerSlider(
                      enginePower: enginePower,
                      onChanged: (double value) {
                        setState(() {
                          enginePower = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: PriceSlider(
                      price: price,
                      onChanged: (double value) {
                        setState(() {
                          price = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                cursorColor: Color(0xFF00A8E8),
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Opis',
                  hintText: 'Opis samochodu',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
      ),
      bottomNavigationBar: FooterWidget(),
    );
  }
}
