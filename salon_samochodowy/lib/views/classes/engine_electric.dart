class Engine_Electirc {
  final int id;
  final double power;
  final String fuelType;
  final double capacity;

  Engine_Electirc({
    required this.id,
    required this.power,
    required this.fuelType,
    required this.capacity,
  });

  factory Engine_Electirc.fromJson(Map<String, dynamic> json) {
    return Engine_Electirc(
      id: json['id'],
      power: json['power'].toDouble(),
      fuelType: json['fuelType'],
      capacity: json['capacity'].toDouble(),
    );
  }
}