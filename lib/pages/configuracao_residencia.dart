import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfiguracaoResidencia extends StatefulWidget {
  const ConfiguracaoResidencia({super.key});

  @override
  ConfiguracaoResidenciaState createState() => ConfiguracaoResidenciaState();
}

class ConfiguracaoResidenciaState extends State<ConfiguracaoResidencia> {
  final TextEditingController numPessoasController = TextEditingController();
  final TextEditingController numComodosController = TextEditingController();
  int numPessoas = 1;
  int numComodos = 1;

  // Lista de dispositivos (exemplo)
  List<Map<String, dynamic>> devices = [
    {'name': 'Chuveiro', 'power': 3000, 'type': 'water', 'usage': 0.0},
    {'name': 'Lâmpada', 'power': 60, 'type': 'light', 'usage': 0.0},
    // Adicione outros dispositivos conforme necessário
  ];

  void salvarConfiguracoes() {
    final int? pessoas = int.tryParse(numPessoasController.text);
    final int? comodos = int.tryParse(numComodosController.text);

    if (pessoas != null && pessoas > 0 && comodos != null && comodos > 0) {
      setState(() {
        numPessoas = pessoas;
        numComodos = comodos;
      });

      ajustarConsumoDispositivos();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configurações salvas com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira valores válidos.')),
      );
    }
  }

  void ajustarConsumoDispositivos() {
    for (var device in devices) {
      switch (device['type']) {
        case 'water':
          // Ajusta o consumo de dispositivos de água como chuveiros
          device['usage'] = (device['usage'] as double) * numPessoas;
          break;
        case 'light':
          // Ajusta o consumo de dispositivos de luz com base no número de cômodos
          device['usage'] = (device['usage'] as double) * numComodos;
          break;
        // Adicione mais casos conforme necessário
      }
    }

    // Atualizar o consumo total (se necessário)
    atualizarConsumoTotal();
  }

  void atualizarConsumoTotal() {
    // Lógica para calcular o consumo total baseado nos dispositivos ajustados
    double consumoTotal = 0.0;
    for (var device in devices) {
      consumoTotal += (device['power'] as double) * (device['usage'] as double);
    }

    // Atualize a visualização do consumo total, se necessário
    print('Consumo Total: $consumoTotal kWh');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 98, 104),
        title: const Text(
          'Configuração da Residência',
          style: TextStyle(color: Color.fromARGB(255, 233, 196, 30)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configurações da Residência',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: numPessoasController,
              decoration: const InputDecoration(
                labelText: 'Número de Pessoas',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: numComodosController,
              decoration: const InputDecoration(
                labelText: 'Número de Cômodos',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvarConfiguracoes,
              child: const Text('Salvar Configurações'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Configurações Atuais:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('Número de Pessoas: $numPessoas'),
            Text('Número de Cômodos: $numComodos'),
          ],
        ),
      ),
    );
  }
}
