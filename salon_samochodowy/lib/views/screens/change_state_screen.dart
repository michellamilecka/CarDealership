import 'package:flutter/material.dart';

import '../widgets/add_photo_widget.dart';
import '../widgets/footer_widget.dart';
import '../widgets/header_widget.dart';


class ChangeStateScreen extends StatelessWidget{
  const ChangeStateScreen({super.key, required String title});

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
                child: TextField(
                  cursorColor: Color(0xFF00A8E8),
                  decoration: InputDecoration(
                    labelText: 'Model samochodu', // Etykieta
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Wpisz model samochodu', // Podpowiedź
                    floatingLabelStyle: TextStyle( // Kolor etykiety, gdy pole jest aktywne
                      color: Color(0xFF00A8E8),
                      fontWeight: FontWeight.bold, // Opcjonalnie pogrubienie
                    ),
                    focusedBorder: OutlineInputBorder( // Obramowanie po aktywacji
                      borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder( // Obramowanie w stanie normalnym
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              AddPhotoWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: TextField(
                  cursorColor: Color(0xFF00A8E8),
                  minLines: 2,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Opis', // Etykieta
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Opis samochodu', // Podpowiedź
                    floatingLabelStyle: TextStyle( // Kolor etykiety, gdy pole jest aktywne
                      color: Color(0xFF00A8E8),
                      fontWeight: FontWeight.bold, // Opcjonalnie pogrubienie
                    ),
                    focusedBorder: OutlineInputBorder( // Obramowanie po aktywacji
                      borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder( // Obramowanie w stanie normalnym
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
                    onPressed: (){
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text(
                            'Dodano nowy samochód!',
                            style: TextStyle(
                              color: Colors.black, // Zmiana koloru tekstu tytułu
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                overlayColor: Color(0xFF00A8E8), // Kolor podświetlenia na niebiesko
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
                        borderRadius: BorderRadius.circular(65), // Set the radius here
                      ),
                      overlayColor: Color(0xFF00A8E8), // Kolor podświetlenia na niebiesko
                    ),
                    child: Text(
                      'Zapisz',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )),
              )
            ]
        )
      ),
      bottomNavigationBar: FooterWidget(),
    );
  }
}