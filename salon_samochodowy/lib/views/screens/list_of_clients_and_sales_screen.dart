import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../classes/car.dart';
import '../widgets/header_widget.dart';
import '../widgets/list_of_clients_picker.dart';
import '../classes/client.dart';
import 'client_form_screen.dart';
import '../../config.dart';

class ListOfClientsAndSalesScreen extends StatefulWidget {
  const ListOfClientsAndSalesScreen({super.key, required this.title, required this.car});

  final String title;
  final Car car;

  @override
  _ListOfClientsAndSalesScreenState createState() => _ListOfClientsAndSalesScreenState();
}

class _ListOfClientsAndSalesScreenState extends State<ListOfClientsAndSalesScreen> {
  List<Client> clients = [];
  List<Client> filteredClients = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchClients();
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

  Future<void> fetchClients() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch individual clients
      final individualResponse = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/clients/individual'),
        headers: {'Accept': 'application/json'},
      );
      if (individualResponse.statusCode != 200) {
        throw Exception('Failed to load individual clients: ${individualResponse.statusCode}');
      }

      // Fetch corporate clients
      final corporateResponse = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/clients/corporate'),
        headers: {'Accept': 'application/json'},
      );
      if (corporateResponse.statusCode != 200) {
        throw Exception('Failed to load corporate clients: ${corporateResponse.statusCode}');
      }

      // Parse responses
      final List<dynamic> individualData = jsonDecode(individualResponse.body);
      final List<dynamic> corporateData = jsonDecode(corporateResponse.body);

      // Convert to Client objects
      final individualClients = individualData
          .map((json) => Client.fromIndividualJson(json))
          .toList();
      final corporateClients = corporateData
          .map((json) => Client.fromCorporateJson(json))
          .toList();

      // Combine both lists and sort by id
      final combinedClients = [...individualClients, ...corporateClients]..sort((a, b) => a.id.compareTo(b.id));

      setState(() {
        clients = combinedClients;
        filteredClients = combinedClients;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching clients: $e';
      });
    }
  }

  void filterClients(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredClients = List.from(clients);
      } else {
        filteredClients = clients.where((client) {
          // Dekoduj i normalizuj wszystkie pola do wyszukiwania
          String firstName = _decodeText(client.firstName ?? '').toLowerCase();
          String lastName = _decodeText(client.lastName ?? '').toLowerCase();
          String companyName = _decodeText(client.companyName ?? '').toLowerCase();
          String searchQuery = _decodeText(query).toLowerCase();

          // Sprawdź, czy zapytanie pasuje do imienia, nazwiska lub nazwy firmy
          return firstName.contains(searchQuery) ||
              lastName.contains(searchQuery) ||
              companyName.contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: HeaderWidget(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(_decodeText(errorMessage!)))
          : Column(
        children: [
          Expanded(
            child: ListOfClientsPickerWidget(
              filteredClients: filteredClients,
              onSearch: filterClients,
              car: widget.car,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: Align(
              alignment: Alignment.center, // Przycisk na środku
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue, // Kolor tła
                  shape: BoxShape.circle, // Okrągły kształt
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, size: 30, color: Colors.white), // Ikona "+"
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClientFormScreen(title: 'ClientForm')),
                    );
                    fetchClients(); // odświeżenie listy po powrocie
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}