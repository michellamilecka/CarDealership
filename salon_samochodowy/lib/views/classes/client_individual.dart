class Client_Individual {
  final int id;
  final String address;
  final String phoneNumber;
  final String email;
  final String name;
  final String surname;
  final String pesel;

  Client_Individual({
    required this.id,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.name,
    required this.surname,
    required this.pesel,
  });

  factory Client_Individual.fromJson(Map<String, dynamic> json) {
    return Client_Individual(
      id: json['id'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      name: json['name'],
      surname: json['surname'],
      pesel: json['pesel'],
    );
  }
}
