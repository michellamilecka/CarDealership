import 'package:flutter/material.dart';
import '../widgets/body_type_dropdown.dart';
import '../widgets/drive_type_dropdown.dart';
import '../widgets/engine_power_slider.dart';
import '../widgets/acceleration_slider.dart';
import '../widgets/footer_widget.dart';
import '../widgets/fuel_type_dropdown.dart';
import '../widgets/production_year_dropdown.dart';
import '../widgets/gearbox_type_dropdown.dart';
import '../widgets/header_widget.dart';
import '../widgets/price_slider.dart';
import '../widgets/mileage_slider.dart';
import '../widgets/gasmileage_slider.dart';
import '../widgets/car_condition_dropdown.dart';
import '../widgets/topspeed_slider.dart';
import 'information_about_a_car_screen.dart';
import '../classes/car.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;

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
  double acceleration = 0;
  double topSpeed = 0;
  double gasMileage = 0;
  int? selectedProductionYear;
  double mileage = 0;
  String? selectedCondition;

  // Maps to store per-car dimensions and loading states
  final Map<String, double> _displayWidths = {};
  final Map<String, double> _displayHeights = {};
  final Map<String, bool> _isLoadingImages = {};
  final Map<String, bool> _hasImageFailed = {};
  final Map<String, bool> _dimensionsChecked = {};

  // Set to store IDs of unavailable cars
  Set<String> unavailableCarIds = {};

  void resetFilters() {
    setState(() {
      selectedModel = null;
      selectedBodyType = null;
      selectedDriveType = null;
      selectedFuelType = null;
      selectedGearbox = null;
      selectedCondition = null;
      selectedProductionYear = null;
      enginePower = 0;
      price = 0;
      acceleration = 0;
      topSpeed = 0;
      gasMileage = 0;
      mileage = 0;
      carsFuture = fetchCars();
    });
  }

  Future<List<Car>> filterCars() async {
    List<Car> allCars = await fetchCars();

    return allCars.where((car) {
      final matchesCondition = selectedCondition != null ? car.condition == selectedCondition : true;
      final matchesYearProduction = selectedProductionYear != null ? car.productionYear == selectedProductionYear : true;
      final matchesAcceleration = acceleration > 0 ? car.acceleration <= acceleration : true;
      final matchesTopSpeed = topSpeed > 0 ? car.topSpeed <= topSpeed : true;
      final matchesGasMileage = gasMileage > 0 ? car.gasMileage <= gasMileage : true;
      final matchesMileage = mileage > 0.0 ? car.mileage <= mileage : true;
      final matchesPrice = price > 0 ? car.price <= price : true;
      final matchesCarBody = selectedBodyType != null ? car.bodyType == selectedBodyType : true;
      final matchesDrivetrain = selectedDriveType != null ? car.drivetrainType == selectedDriveType : true;
      final matchesFuelType = selectedFuelType != null ? car.engines.any((engine) => engine.fuelType == selectedFuelType) : true;
      final matchesGearbox = selectedGearbox != null ? car.transmission == selectedGearbox : true;
      return matchesPrice &&
          matchesCondition &&
          matchesAcceleration &&
          matchesTopSpeed &&
          matchesMileage &&
          matchesGasMileage &&
          matchesYearProduction &&
          matchesCarBody &&
          matchesDrivetrain &&
          matchesFuelType &&
          matchesGearbox;
    }).toList();
  }

  Future<List<Car>> fetchCars() async {
    final response = await http.get(Uri.parse('http://192.168.68.103:8080/api/cars'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Car> cars = data.map((carJson) => Car.fromJson(carJson)).toList();
      print('Fetched cars: ${cars.map((car) => 'ID: ${car.id}, Name: ${car.name}, Drivetrain: ${car.drivetrainType}').toList()}');
      return cars;
    } else {
      print('Failed to fetch cars: ${response.statusCode} - ${response.reasonPhrase}');
      throw Exception('Failed to load cars: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  // Updated method to fetch transactions based on provided JSON structure
  Future<void> fetchTransactions() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.68.103:8080/api/transactions'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          unavailableCarIds = data
              .map((transaction) => transaction['car']['id'].toString())
              .toSet();
          print('Unavailable car IDs: $unavailableCarIds');
        });
      } else {
        print('Failed to fetch transactions: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception('Failed to load transactions: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  Future<void> _checkImageDimensions(String carId) async {
    if (_dimensionsChecked[carId] == true) {
      return;
    }

    print('Starting _checkImageDimensions for car $carId');

    _dimensionsChecked[carId] = true;
    _isLoadingImages[carId] = true;
    _hasImageFailed[carId] = false;

    if (mounted) setState(() {});

    try {
      final response = await http.get(Uri.parse('http://192.168.68.103:8080/api/cars/$carId/image'));
      if (response.statusCode == 200) {
        final originalImage = img.decodeImage(response.bodyBytes);
        if (originalImage != null) {
          if (mounted) {
            setState(() {
              if (originalImage.width > 1128 || originalImage.height > 921) {
                _displayWidths[carId] = 150.0;
                _displayHeights[carId] = 65.0;
              } else {
                _displayWidths[carId] = 150.0;
                _displayHeights[carId] = 120.0;
              }
              _isLoadingImages[carId] = false;
              _hasImageFailed[carId] = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _displayWidths[carId] = 150.0;
              _displayHeights[carId] = 120.0;
              _isLoadingImages[carId] = false;
              _hasImageFailed[carId] = true;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _displayWidths[carId] = 150.0;
            _displayHeights[carId] = 120.0;
            _isLoadingImages[carId] = false;
            _hasImageFailed[carId] = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _displayWidths[carId] = 150.0;
          _displayHeights[carId] = 120.0;
          _isLoadingImages[carId] = false;
          _hasImageFailed[carId] = true;
        });
      }
    }
  }

  late Future<List<Car>> carsFuture;

  @override
  void initState() {
    super.initState();
    carsFuture = fetchCars();
    fetchTransactions();
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtry',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.black),
                    tooltip: 'Wyczyść filtry',
                    onPressed: resetFilters,
                  ),
                ],
              ),
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ProductionYearDropdown(
                        selectedYear: selectedProductionYear,
                        onChanged: (int newYear) {
                          setState(() {
                            selectedProductionYear = newYear;
                          });
                        },
                        years: availableYears,
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
                            print('Selected drive type: $newValue');
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
                      child: CarConditionDropdown(
                        selectedCondition: selectedCondition,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCondition = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PriceSlider(
                  price: price,
                  onChanged: (double value) {
                    setState(() {
                      price = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                AccelerationSlider(
                  acceleration: acceleration,
                  onChanged: (double value) {
                    setState(() {
                      acceleration = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TopspeedSlider(
                  topSpeed: topSpeed,
                  onChanged: (double value) {
                    setState(() {
                      topSpeed = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                GasmileageSlider(
                  gasMileage: gasMileage,
                  onChanged: (double value) {
                    setState(() {
                      gasMileage = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                MileageSlider(
                  mileage: mileage,
                  onChanged: (double value) {
                    setState(() {
                      mileage = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      carsFuture = filterCars();
                    });
                  },
                  icon: Icon(Icons.search, color: Colors.black),
                  label: Text(
                    'Wyszukaj',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Car>>(
              future: carsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Brak danych samochodów.'));
                } else {
                  List<Car> cars = snapshot.data!;
                  return Column(
                    children: cars.map((car) {
                      String carId = car.id.toString();
                      bool isUnavailable = unavailableCarIds.contains(carId);

                      if (_dimensionsChecked[carId] != true) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _checkImageDimensions(carId);
                        });
                      }

                      final isLoading = _isLoadingImages[carId] ?? true;
                      final hasFailed = _hasImageFailed[carId] ?? false;
                      final displayWidth = _displayWidths[carId] ?? 150.0;
                      final displayHeight = _displayHeights[carId] ?? 120.0;

                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => InformationAboutACarScreen(car: car)),
                            ).then((_) {
                              setState(() {
                                carsFuture = filterCars();
                                fetchTransactions(); // Refresh transactions after returning
                              });
                            });
                          },
                          child: Container(
                            width: 380,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                                  child: Container(
                                    height: 65.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: isLoading
                                          ? Container(
                                        height: displayHeight,
                                        width: displayWidth,
                                        color: Colors.grey[200],
                                        child: const Center(child: CircularProgressIndicator()),
                                      )
                                          : hasFailed
                                          ? Image.asset(
                                        'assets/star.png',
                                        height: displayHeight,
                                        width: displayWidth,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.network(
                                        'http://192.168.68.103:8080/api/cars/$carId/image',
                                        height: displayHeight,
                                        width: displayWidth,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          if (mounted) {
                                            setState(() {
                                              _hasImageFailed[carId] = true;
                                            });
                                          }
                                          return Image.asset(
                                            'assets/star.png',
                                            height: displayHeight,
                                            width: displayWidth,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          car.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (isUnavailable)
                                          Text(
                                            'Niedostępny',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: FooterWidget(),
    );
  }
}