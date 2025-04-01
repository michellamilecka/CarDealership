class Engine {
  final int id;
  final double power;
  final String fuelType;

  Engine({
    required this.id,
    required this.power,
    required this.fuelType,
  });

  factory Engine.fromJson(Map<String, dynamic> json) {
    return Engine(
      id: json['id'],
      power: json['power'].toDouble(),
      fuelType: json['fuelType'],
    );
  }
}