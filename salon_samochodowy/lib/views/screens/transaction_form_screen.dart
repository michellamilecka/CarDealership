import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../classes/car.dart';
import '../widgets/header_widget.dart';
import '../../config.dart';
import '../classes/client.dart';

class TransactionFormScreen extends StatefulWidget {
  final String title;
  final Car car;
  final Client client;

  const TransactionFormScreen({
    super.key,
    required this.title,
    required this.car,
    required this.client,
  });

  @override
  _TransactionFormScreenState createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  late TextEditingController _totalAmountController;
  final _paymentMethodController = TextEditingController();
  final _clientIdController = TextEditingController();
  final _carIdController = TextEditingController();
  bool _registered = false;
  bool _insured = false;

  @override
  void initState() {
    super.initState();

    // Ustaw klienta i auto w kontrolerach
    _totalAmountController = TextEditingController(text: widget.car.price.toString());
    _clientIdController.text = widget.client.id.toString();
    _carIdController.text = widget.car.id.toString();
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _paymentMethodController.dispose();
    _clientIdController.dispose();
    _carIdController.dispose();
    super.dispose();
  }

  // Decode text to handle Polish characters
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

  // Manually fix Polish characters
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

  // Funkcja do formatowania polskich znaków
  String _formatPolishText(String text) {
    if (text.isEmpty) return text;
    String decoded = _decodeText(text);
    return decoded[0].toUpperCase() + decoded.substring(1).toLowerCase();
  }

  Future<void> _submitForm() async {
    // Sprawdź walidację formularza
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final Map<String, dynamic> transactionData = {
      'totalAmount': double.tryParse(_totalAmountController.text),
      'paymentMethod': _formatPolishText(_paymentMethodController.text),
      'registered': _registered,
      'insured': _insured,
      'clientId': int.tryParse(_clientIdController.text),
      'carId': int.tryParse(_carIdController.text),
    };

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/transactions'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(transactionData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Pokaż dialog sukcesu
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF00A8E8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Sukces',
                    style: TextStyle(
                      color: Color(0xFF00A8E8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: const Text(
                'Dodano transakcję',
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Zamknij dialog
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF00A8E8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        // Wróć do ekranu głównego, a następnie przejdź do /cars
        if (mounted) {
          Navigator.popUntil(context, ModalRoute.withName('/')); // Wróć do ekranu głównego
          Navigator.pushNamed(context, '/cars'); // Przejdź do CarsScreen
        }
      } else {
        throw Exception('Nie udało się dodać transakcji: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Błąd: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  InputDecoration _blueInputDecoration({required String labelText, String? hintText}) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF00A8E8), width: 1.5),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Przygotuj tekst klienta do wyświetlenia
    final clientInfo = widget.client.displayName.isNotEmpty
        ? _decodeText(widget.client.displayName)
        : 'Brak danych klienta';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: HeaderWidget(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Klient: $clientInfo',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Auto: ${_decodeText(widget.car.name)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'Formularz transakcji',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _totalAmountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: _blueInputDecoration(
                  labelText: 'Kwota całkowita',
                  hintText: 'Wpisz kwotę transakcji',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Proszę wpisać kwotę';
                  if (double.tryParse(value) == null) return 'Nieprawidłowa kwota';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _paymentMethodController.text.isNotEmpty ? _paymentMethodController.text : null,
                items: ['Gotówka', 'Karta kredytowa', 'Przelew']
                    .map((method) => DropdownMenuItem(
                  value: method,
                  child: Text(method),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _paymentMethodController.text = value!;
                  });
                },
                decoration: _blueInputDecoration(labelText: 'Metoda płatności'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Proszę wybrać metodę płatności' : null,
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                title: const Text(
                  'Zarejestrowany',
                  style: TextStyle(color: Colors.black),
                ),
                activeColor: const Color(0xFF00A8E8),
                value: _registered,
                onChanged: (value) {
                  setState(() {
                    _registered = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text(
                  'Ubezpieczenie',
                  style: TextStyle(color: Colors.black),
                ),
                activeColor: const Color(0xFF00A8E8),
                value: _insured,
                onChanged: (value) {
                  setState(() {
                    _insured = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _decodeText(_errorMessage!),
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A8E8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Dodaj transakcję',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}