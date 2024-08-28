import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CONFIMODEL {
  final int users;
  final int comod;
  CONFIMODEL({
    required this.users,
    required this.comod,
  });

  // Construtor Factory para converter JSON em objeto Dart
  factory CONFIMODEL.fromJson(Map<String, dynamic> json) {
    return CONFIMODEL(
      users: json['users'],
      comod: json['comod'],
    );
  }

  // Método para converter objeto Dart em um Map
  Map<String, dynamic> toMap() {
    return {
      'users': users,
      'comod': comod,
    };
  }
}

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

  // Carregar as configurações salvas ao iniciar a tela
  @override
  void initState() {
    super.initState();
    carregarConfiguracoes();
  }

  // Método para carregar configurações salvas do Firestore
  Future<void> carregarConfiguracoes() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('configuracoes')
          .doc('residencia')
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          numPessoas = data['users'] ?? 1;
          numComodos = data['comod'] ?? 1;
          numPessoasController.text = numPessoas.toString();
          numComodosController.text = numComodos.toString();
        });
      }
    } catch (e) {
      print('Erro ao carregar as configurações: $e');
    }
  }

  // Método para salvar as configurações no Firestore
  Future<void> salvarConfiguracoes() async {
    final int? pessoas = int.tryParse(numPessoasController.text);
    final int? comodos = int.tryParse(numComodosController.text);

    if (pessoas != null && pessoas > 0 && comodos != null && comodos > 0) {
      setState(() {
        numPessoas = pessoas;
        numComodos = comodos;
      });

      ajustarConsumoDispositivos();

      // Criar o objeto para salvar
      CONFIMODEL config = CONFIMODEL(users: numPessoas, comod: numComodos);

      try {
        await FirebaseFirestore.instance
            .collection('configuracoes')
            .doc('residencia')
            .set(config.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configurações salvas com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar configurações.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira valores válidos.')),
      );
    }
  }

  void ajustarConsumoDispositivos() {
    // Lógica de ajuste de consumo dos dispositivos
    // Atualizar consumo total se necessário
    atualizarConsumoTotal();
  }

  void atualizarConsumoTotal() {
    // Lógica para calcular o consumo total
    double consumoTotal = 0.0;
    // Exemplo de cálculo
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
