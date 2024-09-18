import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatelessWidget {
  final Map<String, double> dailyConsumption;
  final Map<String, double> monthlyConsumption;
  final Map<String, double> yearlyConsumption;

  const BarChartWidget({
    super.key,
    required this.dailyConsumption,
    required this.monthlyConsumption,
    required this.yearlyConsumption,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Borda arredondada
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Cor da sombra
            spreadRadius: 2, // Expansão da sombra
            blurRadius: 4, // Desfoque da sombra
            offset: const Offset(0, 2), // Posição da sombra
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 1.3,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              titlesData: const FlTitlesData(show: true),
              borderData: FlBorderData(show: false),
              barGroups: _generateBarGroups(),
              gridData: const FlGridData(show: false),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    final List<BarChartGroupData> barGroups = [];
    final List<String> categories = dailyConsumption.keys.toList();

    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: dailyConsumption[category] ?? 0,
              color: Colors.blue,
              width: 16,
            ),
            BarChartRodData(
              toY: monthlyConsumption[category] ?? 0,
              color: Colors.green,
              width: 16,
            ),
            BarChartRodData(
              toY: yearlyConsumption[category] ?? 0,
              color: Colors.red,
              width: 16,
            ),
          ],
        ),
      );
    }

    return barGroups;
  }
}
