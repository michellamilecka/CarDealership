import 'engine.dart';

class Car {
  final int id;
  final String name;
  final String model;
  final String color;
  final double acceleration;
  final String transmission;
  final double topSpeed;
  final double gasMileage;
  final String drivetrainType;
  final String description;
  final String bodyType;
  final double price;
  final String imagePath;
  final String vinNumber;
  final int productionYear;
  final List<Engine> engines;

  Car({
    required this.id,
    required this.name,
    required this.model,
    required this.color,
    required this.acceleration,
    required this.transmission,
    required this.topSpeed,
    required this.gasMileage,
    required this.drivetrainType,
    required this.description,
    required this.bodyType,
    required this.price,
    required this.imagePath,
    required this.vinNumber,
    required this.productionYear,
    required this.engines,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      color: json['color'],
      acceleration: json['acceleration'],
      transmission: json['transmission'],
      topSpeed: json['topSpeed'],
      gasMileage: json['gasMileage'],
      drivetrainType: json['drivetrainType'],
      description: json['description'],
      bodyType: json['bodyType'],
      price: json['price'],
      imagePath: json['imagePath'],
      vinNumber: json['vinNumber'],
      productionYear: json['productionYear'],
      engines: (json['engines'] as List)
          .map((engine) => Engine.fromJson(engine))
          .toList(),
    );
  }
}
