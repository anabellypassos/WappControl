import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fl_chart/fl_chart.dart';
import 'tela_2.dart';
import 'configuracao_residencia.dart';
import '../page1_store.dart';
import '../todoModel.dart';

class Page1 extends StatelessWidget {
  final Page1Store _store = Page1Store();

  Page1({super.key});

  @override
  Widget build(BuildContext context) {
    _store.fetchDevices(); // Chamar o método para buscar os dispositivos

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 98, 104),
        title: Row(
          children: [
            Image.asset(
              'assets/img/logo.png',
              height: 60,
            ),
            const SizedBox(width: 8),
            const Text(
              'Watt Control',
              style: TextStyle(
                color: Color.fromARGB(255, 233, 196, 30),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Color.fromARGB(255, 233, 196, 30),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConfiguracaoResidencia()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Dispositivos Cadastrados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Observer(
                builder: (_) {
                  if (_store.devices.isEmpty) {
                    return const Center(
                        child: Text('Nenhum dispositivo encontrado.'));
                  }

                  // Calcula o consumo por categoria
                  Map<String, double> categoryConsumption = {};
                  for (var device in _store.devices) {
                    double dailyConsumption = device.getDailyConsumption();
                    categoryConsumption.update(
                        device.category, (value) => value + dailyConsumption,
                        ifAbsent: () => dailyConsumption);
                  }

                  return Column(
                    children: [
                      // Gráfico de Pizza
                      PieChartWidget(categoryConsumption: categoryConsumption),

                      const SizedBox(height: 16.0),

                      // Lista de dispositivos
                      Expanded(
                        child: ListView.builder(
                          itemCount: _store.devices.length,
                          itemBuilder: (context, index) {
                            DeviceModel device = _store.devices[index];

                            // Calcular os consumos
                            double dailyConsumption =
                                device.getDailyConsumption();
                            double monthlyConsumption =
                                device.getMonthlyConsumption();
                            double yearlyConsumption =
                                device.getYearlyConsumption();

                            return Card(
                              child: ListTile(
                                title: Text(device.name),
                                subtitle: Text(
                                  'Potência: ${device.power}W\n'
                                  'Uso diário: ${device.usage}h\n'
                                  'Consumo diário: ${dailyConsumption.toStringAsFixed(2)} kWh\n'
                                  'Consumo mensal: ${monthlyConsumption.toStringAsFixed(2)} kWh\n'
                                  'Consumo anual: ${yearlyConsumption.toStringAsFixed(2)} kWh',
                                ),
                                trailing: Text('Categoria: ${device.category}'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        hoverColor: Colors.black45,
        backgroundColor: const Color.fromARGB(255, 96, 98, 104),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Tela2()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 233, 196, 30),
        ),
      ),
    );
  }
}

class PieChartWidget extends StatefulWidget {
  final Map<String, double> categoryConsumption;

  const PieChartWidget({super.key, required this.categoryConsumption});

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  String? _selectedCategory;
  Color? _selectedCategoryColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
            borderRadius:
                BorderRadius.circular(12), // Borda arredondada no gráfico
            child: AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  sections: _generateSections(),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (event is FlTapUpEvent &&
                          pieTouchResponse != null &&
                          pieTouchResponse.touchedSection != null) {
                        final categoryIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                        final category = widget.categoryConsumption.keys
                            .elementAt(categoryIndex);
                        final color = _generateSections()[categoryIndex].color;
                        setState(() {
                          _selectedCategory = category;
                          _selectedCategoryColor = color;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryList(),
                if (_selectedCategory != null && _selectedCategoryColor != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: _selectedCategoryColor,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Categoria: $_selectedCategory',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    final List<Color> colors = [
      Colors.blue,
      Colors.yellow,
      Colors.purple,
      Colors.green,
      Colors.red,
    ];

    List<Widget> categoryWidgets = [];
    int index = 0;
    widget.categoryConsumption.forEach((category, _) {
      categoryWidgets.add(
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              color: colors[index % colors.length],
            ),
            const SizedBox(width: 8.0),
            Text(
              category,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
      index++;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categoryWidgets,
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
    widget.categoryConsumption.forEach((category, consumption) {
      sections.add(
        PieChartSectionData(
          color: colors[index % colors.length],
          value: consumption,
          title:
              '${(consumption / widget.categoryConsumption.values.reduce((a, b) => a + b) * 100).toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      index++;
    });

    return sections;
  }
}
