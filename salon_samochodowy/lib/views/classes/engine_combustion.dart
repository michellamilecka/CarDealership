class Engine_Combustion {
  final int id;
  final double power;
  final String fuelType;
  final double displacement;
  final int cylindersNumber;

  Engine_Combustion({
    required this.id,
    required this.power,
    required this.fuelType,
    required this.displacement,
    required this.cylindersNumber,
  });

  factory Engine_Combustion.fromJson(Map<String, dynamic> json) {
    return Engine_Combustion(
      id: json['id'],
      power: json['power'].toDouble(),
      fuelType: json['fuelType'],
      displacement: json['displacement'].toDouble(),
      cylindersNumber: json['cylindersNumber'],
    );
  }
}