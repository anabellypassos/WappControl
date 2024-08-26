import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceModel {
  final String name;
  final int power;
  final String category;
  final double usage;
  final double usageInMinutes;
  final int daysUsed;

  DeviceModel({
    required this.name,
    required this.power,
    required this.category,
    required this.usage,
    required this.usageInMinutes,
    required this.daysUsed,
  });

  // Construtor Factory para converter JSON em objeto Dart
  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      name: json['name'],
      power: json['power'],
      category: json['category'],
      usage: json['usage'].toDouble(),
      usageInMinutes: json['usageInMinutes'].toDouble(),
      daysUsed: json['daysUsed'],
    );
  }

  // Método para converter objeto Dart em um Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'power': power,
      'category': category,
      'usage': usage,
      'usageInMinutes': usageInMinutes,
      'daysUsed': daysUsed,
    };
  }

  // Método para criar uma cópia do objeto com alterações opcionais
  DeviceModel copyWith({
    String? name,
    int? power,
    String? category,
    double? usage,
    double? usageInMinutes,
    int? daysUsed,
  }) {
    return DeviceModel(
      name: name ?? this.name,
      power: power ?? this.power,
      category: category ?? this.category,
      usage: usage ?? this.usage,
      usageInMinutes: usageInMinutes ?? this.usageInMinutes,
      daysUsed: daysUsed ?? this.daysUsed,
    );
  }
}
