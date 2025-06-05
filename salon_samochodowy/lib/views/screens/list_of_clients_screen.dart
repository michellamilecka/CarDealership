import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/header_widget.dart';
import '../widgets/list_of_clients_widget.dart';
import '../classes/client.dart';
import '../../config.dart';

class ListOfClientsScreen extends StatefulWidget {
  const ListOfClientsScreen({super.key, required this.title});

  final String title;

  @override
  _ListOfClientsScreenState createState() => _ListOfClientsScreenState();
}

class _ListOfClientsScreenState extends State<ListOfClientsScreen> {
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
      return client.displayName.toLowerCase().contains(query.toLowerCase());
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
          : ListOfClientsWidget(
        filteredClients: filteredClients,
        onSearch: filterClients,
      ),
    );
  }
}