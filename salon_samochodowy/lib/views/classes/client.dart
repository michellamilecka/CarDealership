class Client {
  final int id;
  final String address;
  final String phoneNumber;
  final String email;

  Client({
    required this.id,
    required this.address,
    required this.phoneNumber,
    required this.email,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
    );
  }
}
