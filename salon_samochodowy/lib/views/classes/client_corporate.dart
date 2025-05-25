class Client_Corporate {
  final int id;
  final String address;
  final String phoneNumber;
  final String email;
  final String companyName;
  final String nip;

  Client_Corporate({
    required this.id,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.companyName,
    required this.nip,
  });

  factory Client_Corporate.fromJson(Map<String, dynamic> json) {
    return Client_Corporate(
      id: json['id'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      companyName: json['companyName'],
      nip: json['nip'],
    );
  }
}
