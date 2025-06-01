import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/header_widget.dart';
import '../../config.dart';

class ClientFormScreen extends StatefulWidget {
  final String title;

  const ClientFormScreen({super.key, required this.title});

  @override
  _ClientFormScreenState createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _clientType = 'individual'; // Domyślny typ klienta
  bool _isLoading = false;
  String? _errorMessage;

  // Kontrolery dla pól formularza
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _peselController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _nipController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _peselController.dispose();
    _companyNameController.dispose();
    _nipController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final address = '${_streetController.text}, ${_cityController.text}, ${_postalCodeController.text}';
    final Map<String, dynamic> clientData = {
      'type': _clientType,
      'address': address,
      'phoneNumber': _phoneController.text,
      'email': _emailController.text,
    };

    if (_clientType == 'individual') {
      clientData.addAll({
        'name': _nameController.text,
        'surname': _surnameController.text,
        'pesel': _peselController.text,
      });
    } else {
      clientData.addAll({
        'companyName': _companyNameController.text,
        'nip': _nipController.text,
      });
    }

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/clients'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(clientData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _formKey.currentState!.reset();
        _nameController.clear();
        _surnameController.clear();
        _peselController.clear();
        _companyNameController.clear();
        _nipController.clear();
        _emailController.clear();
        _phoneController.clear();
        _streetController.clear();
        _postalCodeController.clear();
        _cityController.clear();

        // Pokaż AlertDialog z komunikatem o sukcesie
        showDialog(
          context: context,
          barrierDismissible: false, // Użytkownik musi kliknąć OK, aby zamknąć
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF00A8E8), // Niebieskie tło ikony
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white, // Biała ikona
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Sukces',
                    style: TextStyle(
                      color: Color(0xFF00A8E8), // Niebieski kolor tytułu
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: const Text('Klient został dodany pomyślnie!'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                // Usunięto obramowanie (side)
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Zamknij dialog
                    Navigator.pop(context, true); // Wróć do poprzedniego ekranu z wynikiem
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Color(0xFF00A8E8), // Niebieski kolor tekstu przycisku
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );

          },
        );
      } else {
        throw Exception('Nie udało się dodać klienta: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Błąd: $e';
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Formularz klienta',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Typ klienta',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _clientType,
                  decoration: InputDecoration(
                    labelText: 'Wybierz typ klienta',
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'individual',
                      child: Text('Indywidualny'),
                    ),
                    DropdownMenuItem(
                      value: 'corporate',
                      child: Text('Korporacyjny'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _clientType = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Dane klienta',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_clientType == 'individual') ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          cursorColor: Color(0xFF00A8E8),
                          decoration: InputDecoration(
                            labelText: 'Imię',
                            labelStyle: TextStyle(color: Colors.grey),
                            hintText: 'Wpisz imię klienta',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF00A8E8), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Proszę wpisać imię';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _surnameController,
                          cursorColor: Color(0xFF00A8E8),
                          decoration: InputDecoration(
                            labelText: 'Nazwisko',
                            labelStyle: TextStyle(color: Colors.grey),
                            hintText: 'Wpisz nazwisko klienta',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF00A8E8), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Proszę wpisać nazwisko';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _peselController,
                    cursorColor: Color(0xFF00A8E8),
                    decoration: InputDecoration(
                      labelText: 'PESEL',
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'Wpisz PESEL klienta',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Proszę wpisać PESEL';
                      }
                      if (value.length != 11 || !RegExp(r'^\d+$').hasMatch(value)) {
                        return 'PESEL musi mieć 11 cyfr';
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  TextFormField(
                    controller: _companyNameController,
                    cursorColor: Color(0xFF00A8E8),
                    decoration: InputDecoration(
                      labelText: 'Nazwa firmy',
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'Wpisz nazwę firmy',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Proszę wpisać nazwę firmy';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nipController,
                    cursorColor: Color(0xFF00A8E8),
                    decoration: InputDecoration(
                      labelText: 'NIP',
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'Wpisz NIP firmy',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Proszę wpisać NIP';
                      }
                      if (value.length != 10 || !RegExp(r'^\d+$').hasMatch(value)) {
                        return 'NIP musi mieć 10 cyfr';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  cursorColor: Color(0xFF00A8E8),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Wpisz email klienta',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Proszę wpisać email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Proszę wpisać poprawny email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  cursorColor: Color(0xFF00A8E8),
                  decoration: InputDecoration(
                    labelText: 'Numer telefonu',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Wpisz numer telefonu klienta',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Proszę wpisać numer telefonu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Adres zamieszkania klienta',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _streetController,
                  cursorColor: Color(0xFF00A8E8),
                  decoration: InputDecoration(
                    labelText: 'Ulica numer domu/mieszkania',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Wpisz adres zamieszkania klienta',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Proszę wpisać adres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _postalCodeController,
                        cursorColor: Color(0xFF00A8E8),
                        decoration: InputDecoration(
                          labelText: 'Kod pocztowy',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: 'Wpisz kod pocztowy',
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Proszę wpisać kod pocztowy';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        cursorColor: Color(0xFF00A8E8),
                        decoration: InputDecoration(
                          labelText: 'Miasto',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: 'Wpisz miasto',
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Proszę wpisać miasto';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A8E8),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    'Dodaj klienta',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}