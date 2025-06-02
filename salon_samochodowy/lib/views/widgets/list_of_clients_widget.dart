import 'dart:convert';

import 'package:flutter/material.dart';
import '../screens/list_of_clients_screen.dart';
import '../screens/information_about_a_client_screen.dart';
import '../classes/client.dart';

class ListOfClientsWidget extends StatelessWidget {
  final List<Client> filteredClients;
  final Function(String) onSearch;

  const ListOfClientsWidget({
    super.key,
    required this.filteredClients,
    required this.onSearch,
  });

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

  @override
  Widget build(BuildContext context) {
    // Debug print to check if data is present
    print('Filtered Clients: ${filteredClients.length}');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Lista klientów',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              labelText: 'Wyszukaj klienta',
              labelStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredClients.length,
            itemBuilder: (context, index) {
              final client = filteredClients[index];
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientInformationScreen(
                            client: client,
                            title: 'Client Details',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 350,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    client.companyName != null
                                        ? _decodeText(client.companyName!)
                                        : '${_decodeText(client.firstName ?? 'N/A')} ${_decodeText(client.lastName ?? 'N/A')}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                  const SizedBox(height: 5),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      _decodeText(client.email),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.black54,
                                      ),
                                      overflow: TextOverflow.visible,
                                      softWrap: false, // Prevent wrapping, let it scroll
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}