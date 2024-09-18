// ignore: file_names
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatefulWidget {
  final Map<String, double> categoryConsumption;

  const PieChartWidget({super.key, required this.categoryConsumption});

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1.3,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: _generateSections(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        _buildLegend(),
      ],
    );
  }

  List<PieChartSectionData> _generateSections() {
    final List<Color> colors = [
      Colors.blue,
      Colors.yellow,
      Colors.purple,
      Colors.green,
      Colors.red,
    ];

    List<PieChartSectionData> sections = [];
    int index = 0;
    double totalConsumption =
        widget.categoryConsumption.values.fold(0, (a, b) => a + b);

    widget.categoryConsumption.forEach((category, consumption) {
      bool isTouched = index == touchedIndex;
      sections.add(
        PieChartSectionData(
          color: colors[index % colors.length],
          value: consumption,
          title:
              '${(consumption / totalConsumption * 100).toStringAsFixed(1)}%',
          radius: isTouched ? 60 : 50,
          titleStyle: TextStyle(
            fontSize: isTouched ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      index++;
    });

    return sections;
  }

  Widget _buildLegend() {
    final List<Color> colors = [
      Colors.blue,
      Colors.yellow,
      Colors.purple,
      Colors.green,
      Colors.red,
    ];

    List<Widget> legendItems = [];
    int index = 0;
    widget.categoryConsumption.forEach((category, consumption) {
      legendItems.add(
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              color: colors[index % colors.length],
            ),
            const SizedBox(width: 8),
            Text(
              '$category: ${(consumption / widget.categoryConsumption.values.fold(0, (a, b) => a + b) * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
      index++;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: legendItems,
    );
  }
}
