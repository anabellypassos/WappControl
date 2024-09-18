import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'tela_2.dart';
import 'configuracao_residencia.dart';
import '../page1_store.dart';
import '../todoModel.dart';
import '../widgets/pieChartWidget.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Dispositivos Cadastrados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // Espaçamento entre o título e o gráfico de pizza
              const SizedBox(height: 50.0), 

              Observer(
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

                      // Espaçamento entre os gráficos
                      const SizedBox(height: 32.0),

                      // Gráfico de Colunas para Consumo
                      BarChartWidget(
                        store: _store,
                        categoryConsumption: categoryConsumption,
                      ),

                      const SizedBox(height: 16.0),

                      // Lista de dispositivos
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(), // Para evitar conflito com o scroll principal
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
                    ],
                  );
                },
              ),
            ],
          ),
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

class BarChartWidget extends StatelessWidget {
  final Page1Store store;
  final Map<String, double> categoryConsumption;

  const BarChartWidget({
    super.key,
    required this.store,
    required this.categoryConsumption,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(),
      title: const ChartTitle(
        text: 'Consumo por Categoria (kWh)',
        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
        ),
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries>[
        ColumnSeries<CategoryConsumption, String>(
          dataSource: _getCategoryConsumptionData(),
          xValueMapper: (CategoryConsumption data, _) => data.category,
          yValueMapper: (CategoryConsumption data, _) => data.daily,
          name: 'Diário',
          color: Colors.blue,
        ),
        ColumnSeries<CategoryConsumption, String>(
          dataSource: _getCategoryConsumptionData(),
          xValueMapper: (CategoryConsumption data, _) => data.category,
          yValueMapper: (CategoryConsumption data, _) => data.monthly,
          name: 'Mensal',
          color: Colors.orange,
        ),
        ColumnSeries<CategoryConsumption, String>(
          dataSource: _getCategoryConsumptionData(),
          xValueMapper: (CategoryConsumption data, _) => data.category,
          yValueMapper: (CategoryConsumption data, _) => data.annual,
          name: 'Anual',
          color: Colors.green,
        ),
      ],
    );
  }

  List<CategoryConsumption> _getCategoryConsumptionData() {
    List<CategoryConsumption> consumptionData = [];

    categoryConsumption.forEach((category, dailyConsumption) {
      double monthlyConsumption =
          dailyConsumption * 30; // Supondo 30 dias no mês
      double annualConsumption =
          dailyConsumption * 365; // Supondo 365 dias no ano
      consumptionData.add(CategoryConsumption(
        category: category,
        daily: dailyConsumption,
        monthly: monthlyConsumption,
        annual: annualConsumption,
      ));
    });

    return consumptionData;
  }
}

class CategoryConsumption {
  final String category;
  final double daily;
  final double monthly;
  final double annual;

  CategoryConsumption({
    required this.category,
    required this.daily,
    required this.monthly,
    required this.annual,
  });
}
