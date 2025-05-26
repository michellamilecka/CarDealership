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
  final int mileage;
  final String drivetrainType;
  final String description;
  final String bodyType;
  final double price;
  final String imagePath;
  final String vinNumber;
  final int productionYear;
  final String condition;
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
    required this.mileage,
    required this.drivetrainType,
    required this.description,
    required this.bodyType,
    required this.price,
    required this.imagePath,
    required this.vinNumber,
    required this.productionYear,
    required this.condition,
    required this.engines,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      color: json['color'],
      acceleration: json['acceleration'].toDouble(), // Upewnij się, że to double
      transmission: json['transmission'],
      topSpeed: json['topSpeed'].toDouble(), // Upewnij się, że to double
      gasMileage: json['gasMileage'].toDouble(), // Upewnij się, że to double
      mileage: json['mileage'],
      drivetrainType: _normalizeDrivetrain(json['drivetrainType']),
      description: json['description'],
      bodyType: json['bodyType'],
      price: json['price'].toDouble(), // Upewnij się, że to double
      imagePath: json['imagePath'],
      vinNumber: json['vinNumber'],
      productionYear: json['productionYear'],
      condition: json['condition'],
      engines: (json['engines'] as List)
          .map((engine) => Engine.fromJson(engine))
          .toList(),
    );
  }

  static String _normalizeDrivetrain(String? drivetrain) {
    if (drivetrain == null) return 'Unknown';
    // Zamiana błędnych znaków na poprawne
    String normalized = drivetrain
        .replaceAll('Ä', 'ę')
        .replaceAll('Ä', 'ą')
        .replaceAll('Å', 'ń')
        .replaceAll('Å', 'ł')
        .replaceAll('Å', 'ś')
        .replaceAll('Å¼', 'ż')
        .replaceAll('Åº', 'ź')
        .replaceAll('Ä', 'ć')
        .replaceAll('Ã³', 'ó');

    // Normalizacja na standardowe wartości

        return normalized; // Zachowaj znormalizowaną wartość, jeśli nie pasuje

  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'color': color,
      'acceleration': acceleration,
      'transmission': transmission,
      'topSpeed': topSpeed,
      'gasMileage': gasMileage,
      'mileage': mileage,
      'drivetrainType': drivetrainType,
      'description': description,
      'bodyType': bodyType,
      'price': price,
      'imagePath': imagePath,
      'vinNumber': vinNumber,
      'productionYear': productionYear,
      'condition': condition,
      'engines': engines.map((engine) => {
        'id': engine.id,
        'power': engine.power,
        'fuelType': engine.fuelType,
      }).toList(),
    };
  }
}