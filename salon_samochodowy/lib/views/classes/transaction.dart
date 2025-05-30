import 'car.dart';
import 'client.dart';

class Transaction {
  final int id;
  final DateTime transactionDate;
  final double totalAmount;
  final String paymentMethod;
  final bool registered;
  final bool insured;
  final Client client;
  final Car car;

  Transaction({
    required this.id,
    required this.transactionDate,
    required this.totalAmount,
    required this.paymentMethod,
    required this.registered,
    required this.insured,
    required this.client,
    required this.car,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      transactionDate: DateTime.parse(json['transactionDate']),
      totalAmount: json['totalAmount'].toDouble(),
      paymentMethod: json['paymentMethod'],
      registered: json['registered'],
      insured: json['insured'],
      client: Client.fromIndividualJson(json['client']),
      car: Car.fromJson(json['car']),
    );
  }
}
