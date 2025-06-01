import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:salon_samochodowy/views/screens/information_about_a_car_screen.dart';
import 'package:salon_samochodowy/views/screens/list_of_clients_and_sales_screen.dart';
import '../screens/client_form_screen.dart';
import '../classes/car.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../../config.dart';

double _parseDouble(String value, double defaultValue) {
  value = value.replaceAll(RegExp(r'[^0-9,.]'), '').replaceAll(',', '.').trim();
  return double.tryParse(value) ?? defaultValue;
}

int _parseInt(String value, int defaultValue) {
  value = value.replaceAll(RegExp(r'[^0-9,.]'), '').replaceAll(',', '.').trim();
  return int.tryParse(value) ?? defaultValue;
}

class InformationAboutACarWidget extends StatefulWidget {
  final Car car;

  const InformationAboutACarWidget({super.key, required this.car});

  @override
  _InformationAboutACarWidgetState createState() => _InformationAboutACarWidgetState();
}

class _InformationAboutACarWidgetState extends State<InformationAboutACarWidget> {
  bool _isEditing = false;
  late List<TextEditingController> _enginePowerControllers;
  late List<TextEditingController> _engineFuelTypeControllers;
  double _displayWidth = 200.0;
  double _displayHeight = 235.0;
  bool _isLoadingImage = true;
  bool _isCarUnavailable = false; // Track car availability

  // Fetch transactions to check if the car is unavailable
  Future<void> _checkCarAvailability() async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/transactions'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        final unavailableCarIds = data
            .map((transaction) => transaction['car']['id'].toString())
            .toSet();
        setState(() {
          _isCarUnavailable = unavailableCarIds.contains(widget.car.id.toString());
          print('Car ${widget.car.id} is ${_isCarUnavailable ? 'unavailable' : 'available'}');
        });
      } else {
        print('Failed to fetch transactions: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  // Show popup for unavailable car
  Future<void> _showUnavailableDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Auto niedostępne',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            'Ten samochód jest niedostępny, ponieważ został już sprzedany.',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkImageDimensions() async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/cars/${widget.car.id}/image'));
      if (response.statusCode == 200) {
        final originalImage = img.decodeImage(response.bodyBytes);
        if (originalImage != null) {
          if (originalImage.width > 1128 || originalImage.height > 921) {
            setState(() {
              _displayWidth = 200.0;
              _displayHeight = 120.0;
              _isLoadingImage = false;
            });
          } else {
            setState(() {
              _isLoadingImage = false;
            });
          }
        } else {
          print('Failed to decode image');
          setState(() {
            _isLoadingImage = false;
          });
        }
      } else {
        print('Failed to load image: ${response.statusCode}');
        setState(() {
          _isLoadingImage = false;
        });
      }
    } catch (e) {
      print('Error loading or checking image dimensions: $e');
      setState(() {
        _isLoadingImage = false;
      });
    }
  }

  Future<void> _deleteCar() async {
    try {
      final response = await http.delete(
        Uri.parse('${AppConfig.baseUrl}/api/cars/${widget.car.id}'),
        headers: {
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Samochód został usunięty!");
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Samochód został usunięty pomyślnie',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        print("Błąd usuwania samochodu: ${response.statusCode}");
        String responseBody = utf8.decode(response.bodyBytes);
        print("Odpowiedź serwera: $responseBody");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Błąd podczas usuwania samochodu')),
        );
      }
    } catch (e) {
      print("Błąd połączenia podczas usuwania samochodu: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd połączenia z serwerem')),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    if (_isCarUnavailable) {
      await _showUnavailableDialog();
      return;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Potwierdzenie usunięcia',
            style: TextStyle(color: Colors.blue),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Czy na pewno chcesz usunąć ten samochód?',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Anuluj',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Usuń',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCar();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateCar() async {
    if (_isCarUnavailable) {
      await _showUnavailableDialog();
      return;
    }

    final carUrl = Uri.parse('${AppConfig.baseUrl}/api/cars');
    final engineUrl = Uri.parse('${AppConfig.baseUrl}/api/engines');

    List<Map<String, dynamic>> updatedEngines = [];
    for (int i = 0; i < _enginePowerControllers.length; i++) {
      String type = _engineFuelTypeControllers[i].text.toLowerCase() == 'elektryczny' ? 'electric' : 'combustion';
      updatedEngines.add({
        "id": i < widget.car.engines.length ? widget.car.engines[i].id : 0,
        "type": type,
        "power": _parseInt(_enginePowerControllers[i].text.replaceAll(' KM', ''),
            i < widget.car.engines.length ? widget.car.engines[i].power.round() : 0),
        "fuelType": _engineFuelTypeControllers[i].text,
      });
    }

    Map<String, dynamic> updatedCar = {
      "id": widget.car.id,
      "name": _nameController.text,
      "model": _modelController.text,
      "color": _colorController.text,
      "acceleration": _parseDouble(_accelerationController.text.replaceAll(' s', ''),
          widget.car.acceleration),
      "transmission": _transmissionController.text,
      "topSpeed": _parseDouble(_topSpeedController.text.replaceAll(' km/h', ''),
          widget.car.topSpeed),
      "gasMileage": _parseDouble(_gasMileageController.text.replaceAll(' l', ''),
          widget.car.gasMileage),
      "mileage": _parseInt(_mileageController.text.replaceAll(' km', ''),
          widget.car.mileage),
      "drivetrainType": _driveTypeController.text,
      "description": _descriptionController.text,
      "bodyType": _bodyTypeController.text,
      "price": _parseDouble(_priceController.text.replaceAll(' PLN', ''),
          widget.car.price),
      "imagePath": widget.car.imagePath,
      "vinNumber": _vinNumberController.text,
      "productionYear": int.tryParse(_productionYearController.text) ?? 1999,
      "condition": _conditionController.text,
    };

    try {
      final carResponse = await http.put(
        carUrl,
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Accept": "application/json",
        },
        body: utf8.encode(jsonEncode(updatedCar)),
      );

      if (carResponse.statusCode == 200) {
        print("Samochód został zaktualizowany!");
      } else {
        print("Błąd aktualizacji samochodu: ${carResponse.statusCode}");
        String responseBody = utf8.decode(carResponse.bodyBytes);
        print("Odpowiedź serwera (samochód): $responseBody");
        return;
      }

      for (var engine in updatedEngines) {
        try {
          print("Wysyłanie żądania dla silnika o ID ${engine['id']}:");
          print("Metoda: PUT");
          print("URL: $engineUrl");
          print("Nagłówki: ${{
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json",
          }}");
          print("Ciało żądania: ${jsonEncode(engine)}");

          final engineResponse = await http.put(
            engineUrl,
            headers: {
              "Content-Type": "application/json; charset=utf-8",
              "Accept": "application/json",
            },
            body: utf8.encode(jsonEncode(engine)),
          );

          if (engineResponse.statusCode == 200) {
            print("Silnik o ID ${engine['id']} został zaktualizowany!");
          } else {
            print("Błąd aktualizacji silnika o ID ${engine['id']}: ${engineResponse.statusCode}");
            String engineResponseBody = utf8.decode(engineResponse.bodyBytes);
            print("Odpowiedź serwera (silnik): $engineResponseBody");
          }
        } catch (e) {
          print("Błąd połączenia podczas aktualizacji silnika o ID ${engine['id']}: $e");
        }
      }
    } catch (e) {
      print("Błąd połączenia podczas aktualizacji samochodu: $e");
    }
  }

  String _decodeText(String text) {
    if (text.isEmpty) return text;

    try {
      if (text.contains('Ä') || text.contains('Ć') || text.contains('ć') ||
          text.contains('Å') || text.contains('Ã') || text.contains('â€')) {
        try {
          List<int> bytes = latin1.encode(text);
          String decoded = utf8.decode(bytes);
          return decoded;
        } catch (e) {
          return _fixPolishCharsManually(text);
        }
      }
      return text;
    } catch (e) {
      return _fixPolishCharsManually(text);
    }
  }

  String _fixPolishCharsManually(String text) {
    return text
        .replaceAll('Ä…', 'ą')
        .replaceAll('Ä™', 'ę')
        .replaceAll('Ä‡', 'ć')
        .replaceAll('Å‚', 'ł')
        .replaceAll('Å„', 'ń')
        .replaceAll('Ã³', 'ó')
        .replaceAll('Åś', 'ś')
        .replaceAll('Å¼', 'ź')
        .replaceAll('Å»', 'ż')
        .replaceAll('Ä„', 'Ą')
        .replaceAll('Ä˜', 'Ę')
        .replaceAll('Ä†', 'Ć')
        .replaceAll('Å', 'Ł')
        .replaceAll('Åƒ', 'Ń')
        .replaceAll('Ã"', 'Ó')
        .replaceAll('Å', 'Ś')
        .replaceAll('Å¹', 'Ź')
        .replaceAll('Å½', 'Ż')
        .replaceAll('â€™', '\'')
        .replaceAll('â€œ', '"')
        .replaceAll('â€', '"')
        .replaceAll('â€"', '–')
        .replaceAll('â€"', '—')
        .replaceAll('Äą', 'ą')
        .replaceAll('Ä™', 'ę')
        .replaceAll('Ĺ‚', 'ł')
        .replaceAll('Ĺ„', 'ń')
        .replaceAll('Ĺś', 'ś')
        .replaceAll('Ĺş', 'ź')
        .replaceAll('Ĺ¼', 'ż');
  }

  late TextEditingController _priceController;
  late TextEditingController _nameController;
  late TextEditingController _colorController;
  late TextEditingController _modelController;
  late TextEditingController _bodyTypeController;
  late TextEditingController _driveTypeController;
  late TextEditingController _transmissionController;
  late TextEditingController _descriptionController;
  late TextEditingController _accelerationController;
  late TextEditingController _topSpeedController;
  late TextEditingController _gasMileageController;
  late TextEditingController _mileageController;
  late TextEditingController _vinNumberController;
  late TextEditingController _productionYearController;
  late TextEditingController _conditionController;

  @override
  void initState() {
    super.initState();
    print('Initializing with car: ${widget.car.toJson()}');
    print('Engines count: ${widget.car.engines?.length ?? 0}');

    _priceController = TextEditingController(text: '${widget.car.price} PLN');
    _colorController = TextEditingController(text: _decodeText(widget.car.color ?? ''));
    _modelController = TextEditingController(text: _decodeText(widget.car.model ?? ''));
    _bodyTypeController = TextEditingController(text: _decodeText(widget.car.bodyType ?? ''));
    _driveTypeController = TextEditingController(text: _decodeText(widget.car.drivetrainType ?? ''));
    _transmissionController = TextEditingController(text: _decodeText(widget.car.transmission ?? ''));
    _descriptionController = TextEditingController(text: _decodeText(widget.car.description ?? ''));
    _nameController = TextEditingController(text: _decodeText(widget.car.name ?? ''));
    _accelerationController = TextEditingController(text: '${widget.car.acceleration} s');
    _topSpeedController = TextEditingController(text: '${widget.car.topSpeed} km/h');
    _gasMileageController = TextEditingController(text: '${widget.car.gasMileage} l');
    _mileageController = TextEditingController(text: '${widget.car.mileage} km');
    _vinNumberController = TextEditingController(text: _decodeText(widget.car

        .vinNumber ?? ''));
    _productionYearController = TextEditingController(text: '${widget.car.productionYear}');
    _conditionController = TextEditingController(text: _decodeText(widget.car.condition ?? ''));

    _enginePowerControllers = [];
    _engineFuelTypeControllers = [];
    if (widget.car.engines != null && widget.car.engines.isNotEmpty) {
      _enginePowerControllers = widget.car.engines
          .map((engine) => TextEditingController(text: '${engine.power} KM'))
          .toList();
      _engineFuelTypeControllers = widget.car.engines
          .map((engine) => TextEditingController(text: _decodeText(engine.fuelType)))
          .toList();
    } else {
      _enginePowerControllers = [TextEditingController(text: 'Brak danych')];
      _engineFuelTypeControllers = [TextEditingController(text: 'Brak danych')];
    }
    print('Initialized _enginePowerControllers length: ${_enginePowerControllers.length}');

    _checkImageDimensions();
    _checkCarAvailability(); // Check car availability on initialization
  }

  @override
  void dispose() {
    _priceController.dispose();
    _nameController.dispose();
    _colorController.dispose();
    _modelController.dispose();
    _bodyTypeController.dispose();
    _driveTypeController.dispose();
    _transmissionController.dispose();
    _descriptionController.dispose();
    _accelerationController.dispose();
    _topSpeedController.dispose();
    _gasMileageController.dispose();
    _mileageController.dispose();
    _vinNumberController.dispose();
    _productionYearController.dispose();
    _conditionController.dispose();
    for (var controller in _enginePowerControllers) {
      controller.dispose();
    }
    for (var controller in _engineFuelTypeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 0.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isEditing)
                  GestureDetector(
                    onTap: _isCarUnavailable ? _showUnavailableDialog : _showDeleteConfirmationDialog,
                    child: Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.blue,
                    ),
                  ),
                if (!_isEditing)
                  GestureDetector(
                    onTap: _isCarUnavailable
                        ? _showUnavailableDialog
                        : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListOfClientsAndSalesScreen(title: 'ListOfClientsAndSales',car: widget.car)),
                      );
                    },
                    child: Icon(
                      Icons.monetization_on,
                      size: 20,
                      color: Colors.blue,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                  child: Text(
                    _decodeText(_nameController.text),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: _isCarUnavailable
                      ? _showUnavailableDialog
                      : () {
                    if (_isEditing) {
                      updateCar();
                    }
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  child: Iconify(
                    _isEditing ? Mdi.check : Mdi.pencil,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 2.0),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: _isLoadingImage
                          ? Container(
                        height: 235.0,
                        width: 200.0,
                        color: Colors.grey[200],
                        child: Center(child: CircularProgressIndicator()),
                      )
                          : Image.network(
                        '${AppConfig.baseUrl}/api/cars/${widget.car.id}/image',
                        height: _displayHeight,
                        width: _displayWidth,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Błąd ładowania obrazka: $error');
                          return Container(
                            height: 235.0,
                            width: 200.0,
                            color: Colors.grey[200],
                            alignment: Alignment.center,
                            child: Text(
                              'Błąd ładowania obrazu',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 280,
                      width: 150,
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: _isEditing
                                    ? TextField(
                                  controller: _descriptionController,
                                  style: TextStyle(fontSize: 12.0, color: Colors.black),
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.all(8.0),
                                  ),
                                )
                                    : Text(
                                  _decodeText(_descriptionController.text),
                                  style: TextStyle(fontSize: 12.0, color: Colors.black),
                                  textAlign: TextAlign.justify,
                                  softWrap: true,
                                  maxLines: null,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    'PARAMETRY',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Iconify(
                  Mdi.wrench,
                  size: 20,
                  color: Colors.black,
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              height: 300,
              width: 350,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        _buildParameterRow('Nazwa', _nameController),
                        _buildParameterRow('Model', _modelController),
                        _buildParameterRow('Cena', _priceController),
                        _buildParameterRow('Rodzaj nadwozia', _bodyTypeController),
                        _buildParameterRow('Rodzaj napędu', _driveTypeController),
                        _buildParameterRow('Przyspieszenie', _accelerationController),
                        _buildParameterRow('Skrzynia biegów', _transmissionController),
                        _buildParameterRow('Kolor', _colorController),
                        _buildParameterRow('Prędkość maksymalna', _topSpeedController),
                        _buildParameterRow('Przebieg', _mileageController),
                        _buildParameterRow('Zużycie paliwa', _gasMileageController),
                        _buildParameterRow('Numer VIN', _vinNumberController),
                        _buildParameterRow('Rok produkcji', _productionYearController),
                        _buildParameterRowWithCondition('Stan', _conditionController),
                        if (_enginePowerControllers != null && _enginePowerControllers.isNotEmpty)
                          _buildParameterRowForEngines(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: 350,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: _isEditing
                  ? SizedBox(
                width: 150,
                child: TextField(
                  controller: controller,
                  style: TextStyle(fontSize: 15.0),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  maxLines: null,
                ),
              )
                  : SizedBox(
                width: 150,
                child: Text(
                  label == 'Prędkość maksymalna' && controller.text == '0.0 km/h' ? 'Brak danych' : _decodeText(controller.text),
                  style: TextStyle(
                    fontSize: label == 'Numer VIN' || label == 'Kolor' ? 12.0 : 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  softWrap: true,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterRowWithCondition(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: 350,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: _isEditing
                  ? SizedBox(
                width: 150,
                child: TextField(
                  controller: controller,
                  style: TextStyle(fontSize: 15.0),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  maxLines: null,
                ),
              )
                  : SizedBox(
                width: 150,
                child: Text(
                  _decodeText(controller.text) != 'nowy' ? 'używany' : _decodeText(controller.text),
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  softWrap: true,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterRowForEngines() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10.0),
              child: Text(
                'Silniki',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _enginePowerControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Moc silnika',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          _isEditing
                              ? SizedBox(
                            width: 150,
                            child: TextField(
                              controller: _enginePowerControllers[index],
                              style: TextStyle(fontSize: 15.0),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                              ),
                              maxLines: 1,
                            ),
                          )
                              : SizedBox(
                            width: 150,
                            child: Text(
                              _decodeText(_enginePowerControllers[index].text),
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Typ paliwa',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: Text(
                              _decodeText(_engineFuelTypeControllers[index].text),
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: _isEditing ? Colors.grey[800] : Colors.black,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      if (index < _enginePowerControllers.length - 1) Divider(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}