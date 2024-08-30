import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart'; // Importação correta para Observer
import 'tela_2.dart';
import 'package:teste/page1_store.dart'; // Ajuste o caminho se necessário
import 'configuracao_residencia.dart';


class Page1 extends StatelessWidget {
  final Page1Store _store = Page1Store();

  Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 98, 104),
        title: Row(
          children: [
            Image.asset(
              'assets/img/logo.png', // Substitua pelo caminho da sua imagem
              height: 60, // Ajuste o tamanho conforme necessário
            ),
            const SizedBox(width: 8), // Espaço entre a imagem e o texto
            Observer(
              builder: (_) => const Text(
                'Watt Control',
                style: TextStyle(
                  color: Color.fromARGB(255, 233, 196, 30),
                ),
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
            MaterialPageRoute(builder: (context) => const ConfiguracaoResidencia()),
          );
        },
              // Navegar para a tela de configurações da residência
          
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Observer(
                builder: (_) => _buildBarChart(_store.barChartTitle),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Observer(
                builder: (_) => _buildPieChart(_store.pieChartTitle),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Observer(
                builder: (_) => _buildDailySummary(_store.dailySummary),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        hoverColor: Colors.black45,
        backgroundColor: const Color.fromARGB(255, 96, 98, 104),
        onPressed: () {
          // Navegar para a tela de adição de dispositivos
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Tela2()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 233, 196, 30),
        ),
      ),
    );
  }

  Widget _buildBarChart(String title) {
    return Container(
      color: Colors.blueAccent.withOpacity(0.2),
      child: Center(child: Text(title)),
    );
  }

  Widget _buildPieChart(String title) {
    return Container(
      color: Colors.greenAccent.withOpacity(0.2),
      child: Center(child: Text(title)),
    );
  }

  Widget _buildDailySummary(String summary) {
    return Container(
      color: Colors.orangeAccent.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summary,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
