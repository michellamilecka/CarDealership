import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import 'package:email_validator/email_validator.dart' show EmailValidator;

class ClientFormScreen extends StatelessWidget {
  const ClientFormScreen({super.key, required String title});

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
                child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                      'Dane klienta',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
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
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // Dodaj odstęp między polami
                      Expanded(
                        child: TextField(
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
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: Color(0xFF00A8E8),
                    decoration: InputDecoration(
                      labelText: 'PESEL/ numer paszportu',
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'Wpisz PESEL klienta',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: Color(0xFF00A8E8),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'Wpisz email klienta',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    cursorColor: Color(0xFF00A8E8),
                    decoration: InputDecoration(
                      labelText: 'Numer telefonu',
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'Wpisz numer telefonu klienta',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
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
                  TextField(
                    cursorColor: Color(0xFF00A8E8),
                    decoration: InputDecoration(
                      labelText: 'Ulica numer domu/mieszkania',
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: 'Wpisz adres zamieszkania klienta',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: Color(0xFF00A8E8),
                          decoration: InputDecoration(
                            labelText: 'Kod pocztowy',
                            labelStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF00A8E8), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // Dodaj odstęp między polami
                      Expanded(
                        child: TextField(
                          cursorColor: Color(0xFF00A8E8),
                          decoration: InputDecoration(
                            labelText: 'Miasto',
                            labelStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF00A8E8), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]))));
  }
}
