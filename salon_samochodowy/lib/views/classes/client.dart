import 'package:flutter/foundation.dart';

class Client {
  final int id;
  final String address;
  final String phoneNumber;
  final String email;
  final String? name; // For individual clients
  final String? surname; // For individual clients
  final String? pesel; // For individual clients
  final String? companyName; // For corporate clients
  final String? nip; // For corporate clients

  Client({
    required this.id,
    required this.address,
    required this.phoneNumber,
    required this.email,
    this.name,
    this.surname,
    this.pesel,
    this.companyName,
    this.nip,
  });

  factory Client.fromIndividualJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      name: json['name'],
      surname: json['surname'],
      pesel: json['pesel'],
    );
  }

  factory Client.fromCorporateJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      companyName: json['companyName'],
      nip: json['nip'],
    );
  }

  String get displayName {
    return companyName != null ? companyName! : '${name ?? ''} ${surname ?? ''}'.trim();
  }

  // Getters to match UI expectations
  String? get firstName => name;
  String? get lastName => surname;
  String get phone => phoneNumber;
}