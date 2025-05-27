import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/acceleration_slider.dart';
import '../widgets/body_type_dropdown.dart';
import '../widgets/gasmileage_slider.dart';
import '../widgets/mileage_slider.dart';
import '../widgets/topspeed_slider.dart';

import '../widgets/add_photo_widget.dart';
import '../widgets/car_condition_dropdown.dart';
import '../widgets/drive_type_dropdown.dart';
import '../widgets/engine_power_slider.dart';
import '../widgets/footer_widget.dart';
import '../widgets/fuel_type_dropdown.dart';
import '../widgets/gearbox_type_dropdown.dart';
import '../widgets/header_widget.dart';
import '../widgets/price_slider.dart';
import '../widgets/production_year_dropdown.dart';

class ChangeStateScreen extends StatefulWidget {
  const ChangeStateScreen({super.key, required String title});

  @override
  _ChangeStateScreenState createState() => _ChangeStateScreenState();
}

class _ChangeStateScreenState extends State<ChangeStateScreen> {
  String? selectedCondition;
  String? selectedModel;
  String? selectedColor;
  double selectedMileage = 0;
  String? selectedBodyType;
  String? selectedDriveType;

  // Silnik 1
  String? selectedFuelType1;
  double selectedEnginePower1 = 0;

  // Silnik 2
  String? selectedFuelType2;
  double selectedEnginePower2 = 0;

  String? selectedGearbox;
  double selectedPrice = 0;
  String? selectedDescription;
  String? selectedName;
  double selectedAcceleration = 0;
  double selectedTopSpeed = 0;
  double selectedGasMileage = 0;
  String selectedImagePath = 'nwm';
  String? selectedVin;
  int? selectedProductionYear;

  Future<int?> addEngine(Map<String, dynamic> engineData, Uri engineUrl) async {
    try {
      final response = await http.post(
        engineUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(engineData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final engineResponseBody = jsonDecode(response.body);
        print('✅ Silnik dodany, id: ${engineResponseBody['id']}');
        return engineResponseBody['id'];
      } else {
        print('❌ Błąd dodawania silnika: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('⚠️ Błąd połączenia przy dodawaniu silnika: $e');
    }
    return null;
  }

  // Teraz sendCarData zwraca bool informujący o sukcesie
  Future<bool> sendCarData() async {
    final engineUrl = Uri.parse('http://192.168.68.103:8080/api/engines');
    final carUrl = Uri.parse('http://192.168.68.103:8080/api/cars');

    List<Map<String, dynamic>> enginesData = [];

    if (selectedFuelType1 != null && selectedFuelType1!.isNotEmpty && selectedEnginePower1 > 0) {
      enginesData.add({
        'type': selectedFuelType1 == 'elektryczny' ? 'electric' : 'combustion',
        'power': selectedEnginePower1,
        'fuelType': selectedFuelType1,
        'capacity': 16.01,
      });
    }

    if (selectedFuelType2 != null && selectedFuelType2!.isNotEmpty && selectedEnginePower2 > 0) {
      enginesData.add({
        'type': selectedFuelType2 == 'elektryczny' ? 'electric' : 'combustion',
        'power': selectedEnginePower2,
        'fuelType': selectedFuelType2,
        'capacity': 16.01,
      });
    }

    List<int> engineIds = [];

    for (var engineData in enginesData) {
      final id = await addEngine(engineData, engineUrl);
      if (id != null) {
        engineIds.add(id);
      } else {
        print('❌ Nie udało się dodać silnika, przerywam.');
        return false;
      }
    }

    int? carId;

    var request = http.MultipartRequest('POST', carUrl);

    Map<String, dynamic> carData = {
      'name': selectedName,
      'model': selectedModel,
      'color': selectedColor,
      'acceleration': selectedAcceleration,
      'transmission': selectedGearbox,
      'topSpeed': selectedTopSpeed,
      'gasMileage': selectedGasMileage,
      'mileage': selectedMileage,
      'drivetrainType': selectedDriveType,
      'description': selectedDescription,
      'bodyType': selectedBodyType,
      'price': selectedPrice,
      'vinNumber': selectedVin,
      'productionYear': selectedProductionYear,
      'condition': selectedCondition,
    };

    request.fields['car'] = jsonEncode(carData);

    File imageFile = File(selectedImagePath);
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final carResponseBody = jsonDecode(response.body);
        carId = carResponseBody['id'];
        print('✅ Samochód dodany, id: $carId');
      } else {
        print('❌ Błąd dodawania samochodu: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('⚠️ Błąd połączenia przy dodawaniu samochodu: $e');
      return false;
    }

    if (carId != null) {
      for (var engineId in engineIds) {
        final assignEngineUrl = Uri.parse('http://192.168.68.103:8080/api/cars/$carId/add-engine/$engineId');

        try {
          final assignResponse = await http.put(assignEngineUrl);

          if (assignResponse.statusCode == 200) {
            print('✅ Silnik $engineId przypisany do samochodu!');
          } else {
            print('❌ Błąd przypisywania silnika $engineId: ${assignResponse.statusCode}, ${assignResponse.body}');
          }
        } catch (e) {
          print('⚠️ Błąd połączenia przy przypisywaniu silnika $engineId: $e');
        }
      }
    }

    return true; // Sukces!
  }

  @override
  Widget build(BuildContext context) {
    List<int> availableYears = List<int>.generate(2025 - 2015 + 1, (index) => 2015 + index);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: HeaderWidget(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddPhotoWidget(
                    onImageSelected: (path) {
                      setState(() {
                        selectedImagePath = path;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(labelText: 'Nazwa'),
                          onChanged: (val) => setState(() => selectedName = val),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(labelText: 'Model'),
                          onChanged: (val) => setState(() => selectedModel = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CarConditionDropdown(
                selectedCondition: selectedCondition,
                onChanged: (val) => setState(() => selectedCondition = val),
              ),

              BodyTypeDropdown(
                selectedBodyType: selectedBodyType,
                onChanged: (val) => setState(() => selectedBodyType = val),
              ),

              DriveTypeDropdown(
                selectedDriveType: selectedDriveType,
                onChanged: (val) => setState(() => selectedDriveType = val),
              ),

              GearboxTypeDropdown(
                selectedGearbox: selectedGearbox,
                onChanged: (val) => setState(() => selectedGearbox = val),
              ),

              ProductionYearDropdown(
                selectedYear: selectedProductionYear,
                years: availableYears,
                onChanged: (val) => setState(() => selectedProductionYear = val),
              ),

              const SizedBox(height: 32),

              Text('Silnik 1'),
              FuelTypeDropdown(
                selectedFuelType: selectedFuelType1,
                onChanged: (val) => setState(() => selectedFuelType1 = val),
              ),
              EnginePowerSlider(
                enginePower: selectedEnginePower1,
                onChanged: (val) => setState(() => selectedEnginePower1 = val),
              ),

              const SizedBox(height: 32),

              Text('Silnik 2 (opcjonalny)'),
              FuelTypeDropdown(
                selectedFuelType: selectedFuelType2,
                onChanged: (val) => setState(() => selectedFuelType2 = val),
              ),
              EnginePowerSlider(
                enginePower: selectedEnginePower2,
                onChanged: (val) => setState(() => selectedEnginePower2 = val),
              ),

              const SizedBox(height: 32),

              AccelerationSlider(
                acceleration: selectedAcceleration,
                onChanged: (val) => setState(() => selectedAcceleration = val),
              ),
              PriceSlider(
                price: selectedPrice,
                onChanged: (val) => setState(() => selectedPrice = val),
              ),
              TopspeedSlider(
                topSpeed: selectedTopSpeed,
                onChanged: (val) => setState(() => selectedTopSpeed = val),
              ),
              GasmileageSlider(
                gasMileage: selectedGasMileage,
                onChanged: (val) => setState(() => selectedGasMileage = val),
              ),
              MileageSlider(
                mileage: selectedMileage,
                onChanged: (val) => setState(() => selectedMileage = val),
              ),

              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Opis'),
                maxLines: 3,
                onChanged: (val) => setState(() => selectedDescription = val),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'VIN'),
                onChanged: (val) => setState(() => selectedVin = val),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(labelText: 'Kolor'),
                maxLines: 3,
                onChanged: (val) => setState(() => selectedColor = val),
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Niebieski kolor tła
                ),
                onPressed: () async {
                  // Lista pól do sprawdzenia (nazwa pola + wartość)
                  final requiredFields = {
                    'Nazwa': selectedName,
                    'Model': selectedModel,
                    'Kolor': selectedColor,
                    'Przebieg': selectedMileage > 0 ? selectedMileage : null,
                    'Typ nadwozia': selectedBodyType,
                    'Typ napędu': selectedDriveType,
                    'Stan samochodu': selectedCondition,
                    'Typ paliwa silnika 1': selectedFuelType1,
                    'Moc silnika 1': selectedEnginePower1 > 0 ? selectedEnginePower1 : null,
                    'Skrzynia biegów': selectedGearbox,
                    'Rok produkcji': selectedProductionYear,
                    'Przyspieszenie': selectedAcceleration > 0 ? selectedAcceleration : null,
                    'Cena': selectedPrice > 0 ? selectedPrice : null,
                    'Prędkość maksymalna': selectedTopSpeed > 0 ? selectedTopSpeed : null,
                    'Zużycie paliwa': selectedGasMileage > 0 ? selectedGasMileage : null,
                    'Opis': selectedDescription,
                    'VIN': selectedVin,
                    'Zdjęcie': selectedImagePath != 'nwm' ? selectedImagePath : null,
                  };

                  // Sprawdzamy, czy którekolwiek z wymaganych pól jest null lub puste
                  String? missingField;
                  requiredFields.forEach((key, value) {
                    if (missingField == null) {
                      if (value == null) {
                        missingField = key;
                      } else if (value is String && value.trim().isEmpty) {
                        missingField = key;
                      }
                    }
                  });

                  if (missingField != null) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Uzupełnij pole: $missingField'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    return;
                  }

                  // Jeśli wszystkie pola są wypełnione, wysyłamy dane
                  bool success = await sendCarData();
                  if (success) {
                    if (!mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pomyślnie dodano samochód!'),
                        backgroundColor: Colors.blue,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Błąd podczas dodawania samochodu.'),
                        backgroundColor: Colors.blue,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Dodaj Samochód',
                  style: TextStyle(color: Colors.white),
                ),
              ),


              const SizedBox(height: 32),

              FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
