import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../widgets/header_widget.dart';
import '../classes/client.dart';
import '../../config.dart';

class ClientInformationScreen extends StatefulWidget {
  final Client client;
  final String title;

  const ClientInformationScreen({
    super.key,
    required this.client,
    required this.title,
  });

  @override
  _ClientInformationScreenState createState() => _ClientInformationScreenState();
}

class _ClientInformationScreenState extends State<ClientInformationScreen> {
  List<dynamic> transactions = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pl', null).then((_) {
      fetchTransactions();
    });
  }

  Future<void> fetchTransactions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/transactions'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> allTransactions = jsonDecode(response.body);
        final clientTransactions = allTransactions
            .where((transaction) => transaction['client']['id'] == widget.client.id)
            .toList();
        setState(() {
          transactions = clientTransactions;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Błąd podczas pobierania transakcji: $e';
      });
    }
  }

  // Function to format Polish characters
  String _formatPolishText(String text) {
    if (text.isEmpty) return text;

    try {
      final latin1Bytes = latin1.encode(text);
      String decoded = utf8.decode(latin1Bytes, allowMalformed: true);
      if (_hasPolishChars(decoded)) return decoded;
    } catch (e) {
      debugPrint('Latin1 decode failed: $e');
    }

    return text
        .replaceAll('Ä…', 'ą')
        .replaceAll('Ä™', 'ę')
        .replaceAll('Ä‡', 'ć')
        .replaceAll('Å‚', 'ł')
        .replaceAll('Å„', 'ń')
        .replaceAll('Ã³', 'ó')
        .replaceAll('Å›', 'ś')
        .replaceAll('Å¼', 'ź')
        .replaceAll('Å¼', 'ż')
        .replaceAll('Ä„', 'Ą')
        .replaceAll('Ä˜', 'Ę')
        .replaceAll('Ä†', 'Ć')
        .replaceAll('Å', 'Ł')
        .replaceAll('Åƒ', 'Ń')
        .replaceAll('Ã“', 'Ó')
        .replaceAll('Åš', 'Ś')
        .replaceAll('Å¹', 'Ź')
        .replaceAll('Å»', 'Ż');
  }

  bool _hasPolishChars(String text) {
    const polishChars = 'ąćęłńóśźżĄĆĘŁŃÓŚŹŻ';
    return text.split('').any((char) => polishChars.contains(char));
  }

  // Function to format transaction date
  String _formatTransactionDate(String dateString) {
    try {
      // Parse the ISO 8601 date string
      final dateTime = DateTime.parse(dateString);
      // Format to a readable Polish format: Dzień Miesiąc Rok
      final formatter = DateFormat('d MMMM yyyy', 'pl');
      return formatter.format(dateTime);
    } catch (e) {
      debugPrint('Date parsing failed: $e');
      return dateString; // Fallback to original string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: HeaderWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatPolishText('Informacje o kliencie'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.client.name != null && widget.client.surname != null) ...[
                      _buildInfoRow(
                          _formatPolishText('Imię i nazwisko'),
                          _formatPolishText('${widget.client.name} ${widget.client.surname}')),
                      _buildInfoRow(
                          _formatPolishText('PESEL'),
                          _formatPolishText(widget.client.pesel ?? 'N/A')),
                    ],
                    if (widget.client.companyName != null) ...[
                      _buildInfoRow(
                          _formatPolishText('Nazwa firmy'),
                          _formatPolishText(widget.client.companyName!)),
                      _buildInfoRow(
                          _formatPolishText('NIP'),
                          _formatPolishText(widget.client.nip ?? 'N/A')),
                    ],
                    _buildInfoRow(
                        _formatPolishText('Adres'),
                        _formatPolishText(widget.client.address)),
                    _buildInfoRow(
                        _formatPolishText('Numer telefonu'),
                        _formatPolishText(widget.client.phone)),
                    _buildInfoRow(
                        _formatPolishText('Email'),
                        _formatPolishText(widget.client.email)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _formatPolishText('Transakcje'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? Center(child: Text(_formatPolishText(errorMessage!)))
                : transactions.isEmpty
                ? Center(
              child: Text(
                _formatPolishText('BRAK DANYCH'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    elevation: 2,
                    color: Colors.grey[100],
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                              _formatPolishText('Data transakcji'),
                              _formatTransactionDate(transaction['transactionDate'])),
                          _buildInfoRow(
                              _formatPolishText('Kwota całkowita'),
                              '${transaction['totalAmount'].toString()} PLN'),
                          _buildInfoRow(
                              _formatPolishText('Metoda płatności'),
                              _formatPolishText(transaction['paymentMethod'])),
                          _buildInfoRow(
                              _formatPolishText('Zarejestrowana'),
                              _formatPolishText(transaction['registered'] ? 'Tak' : 'Nie')),
                          _buildInfoRow(
                              _formatPolishText('Ubezpieczona'),
                              _formatPolishText(transaction['insured'] ? 'Tak' : 'Nie')),
                          _buildInfoRow(
                              _formatPolishText('Samochód'),
                              _formatPolishText('${transaction['car']['name']} (${transaction['car']['model']})')),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    String formattedValue = value;
    if (label == 'Metoda płatności') {
      if (value.toLowerCase() == 'gotówka') {
        formattedValue = 'Gotówka';
      } else if (value.toLowerCase() == 'karta kredytowa') {
        formattedValue = 'Karta kredytowa';
      } else if (value.toLowerCase() == 'przelew') {
        formattedValue = 'Przelew';
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: SizedBox(
              width: 120,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              formattedValue,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}