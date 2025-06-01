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
  const ListOfClientsAndSalesScreen({super.key, required this.title,required this.car});

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
    final results = clients.where((client) {
      return client.lastName?.toLowerCase().contains(query.toLowerCase()) ?? false;
    }).toList();

    setState(() {
      filteredClients = results;
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
          ? Center(child: Text(errorMessage!))
          : Column(
        children: [
          Expanded(
            child: ListOfClientsPickerWidget(
              filteredClients: filteredClients,
              onSearch: filterClients,
              car:widget.car
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20,top:10),
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