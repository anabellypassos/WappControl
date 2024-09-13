class DeviceModel {
  final String name;
  final int power; // Potência em W
  final String category;
  final double usage; // Tempo de uso diário em horas
  final double usageInMinutes; // Tempo de uso diário em minutos
  final int daysUsed; // Número de dias de uso no mês

  DeviceModel({
    required this.name,
    required this.power,
    required this.category,
    required this.usage,
    required this.usageInMinutes,
    required this.daysUsed,
  });

  // Método para calcular o consumo diário em kWh
  double getDailyConsumption() {
    return (power * usage) / 1000; // Potência (W) * Tempo de uso (h) / 1000
  }

  // Método para calcular o consumo mensal em kWh
  double getMonthlyConsumption() {
    return getDailyConsumption() *
        daysUsed; // Consumo diário * dias de uso no mês
  }

  // Método para calcular o consumo anual em kWh
  double getYearlyConsumption() {
    return getDailyConsumption() * 365; // Consumo diário * 365 dias no ano
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
}
