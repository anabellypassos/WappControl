import 'package:flutter/material.dart';
import 'configuracao_residencia.dart';

class Tela2 extends StatefulWidget {
  const Tela2({super.key});

  @override
  _Tela2State createState() => _Tela2State();
}

class _Tela2State extends State<Tela2> {
  final List<Map<String, dynamic>> predefinedDevices = [
    {'name': 'Micro-ondas', 'power': 1100, 'category': 'Cozinha', 'usage': 0.0, 'usageInMinutes': 0.0, 'daysUsed': 1},
    // Adicione mais dispositivos conforme necessário
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController powerController = TextEditingController();
  final TextEditingController daysUsedController = TextEditingController();

  TimeOfDay? selectedTime;
  String selectedTimeFormatted = "00:00";

  String selectedCategory = 'Cozinha';
  int? selectedIndex;

  final List<String> categories = ['Cozinha', 'Iluminação', 'Entretenimento', 'Beleza', 'Outros'];

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        selectedTimeFormatted = '${picked.hour}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void saveDevice() {
    final String name = nameController.text;
    final int? power = int.tryParse(powerController.text);
    final int? daysUsed = int.tryParse(daysUsedController.text);

    if (name.isNotEmpty && power != null && selectedCategory.isNotEmpty && selectedTime != null && daysUsed != null) {
      final double totalHours = selectedTime!.hour + (selectedTime!.minute / 60);
      final double totalMinutes = totalHours * 60;

      setState(() {
        final device = {
          'name': name,
          'power': power,
          'category': selectedCategory, // Atribuir a categoria selecionada
          'usage': (selectedIndex == null ? 0.0 : predefinedDevices[selectedIndex!]['usage']) + totalHours,
          'usageInMinutes': (selectedIndex == null ? 0.0 : predefinedDevices[selectedIndex!]['usageInMinutes']) + totalMinutes,
          'daysUsed': daysUsed,
        };

        if (selectedIndex == null) {
          predefinedDevices.add(device);
        } else {
          predefinedDevices[selectedIndex!] = device;
        }

        _resetForm();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dispositivo salvo com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
    }
  }

  void _resetForm() {
    nameController.clear();
    powerController.clear();
    daysUsedController.clear();
    selectedTimeFormatted = "00:00";
    selectedCategory = categories[0];
    selectedIndex = null;
    selectedTime = null;
  }

  void editDevice(int index) {
    final device = predefinedDevices[index];
    nameController.text = device['name'];
    powerController.text = device['power'].toString();
    daysUsedController.text = device['daysUsed'].toString();
    selectedCategory = device['category']; // Atribuir a categoria ao editar
    selectedTimeFormatted = _formatTimeFromHours(device['usage']);
    selectedIndex = index;
  }

  String _formatTimeFromHours(double hours) {
    final int totalMinutes = (hours * 60).toInt();
    final int hoursPart = totalMinutes ~/ 60;
    final int minutesPart = totalMinutes % 60;
    return '${hoursPart.toString().padLeft(2, '0')}:${minutesPart.toString().padLeft(2, '0')}';
  }

  void deleteDevice(int index) {
    setState(() {
      predefinedDevices.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dispositivo excluído com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 98, 104),
        title: const Text(
          'Cadastro de Dispositivos',
          style: TextStyle(color: Color.fromARGB(255, 233, 196, 30)),
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
                  builder: (context) => const ConfiguracaoResidencia(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dispositivos Pré-definidos:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: predefinedDevices.length,
              itemBuilder: (context, index) {
                final device = predefinedDevices[index];
                final int totalMinutes = (device['usage'] * 60).toInt();
                final int hours = totalMinutes ~/ 60;
                final int minutes = totalMinutes % 60;
                final int daysUsed = device['daysUsed'];
                final double dailyUsageInMinutes = device['usageInMinutes'] / daysUsed;
                return ListTile(
                  title: Text('${device['name']} - ${device['power']}W'),
                  subtitle: Text(
                      'Categoria: ${device['category']}\nUso total: ${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m\nUso diário: ${dailyUsageInMinutes.toStringAsFixed(2)} minutos'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => editDevice(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteDevice(index),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Cadastrar Novo Dispositivo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome do Dispositivo'),
            ),
            TextField(
              controller: powerController,
              decoration: const InputDecoration(labelText: 'Potência (W)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: daysUsedController,
              decoration: const InputDecoration(labelText: 'Número de Dias Usados'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Tempo de Uso Diário:'),
              subtitle: Text(selectedTimeFormatted),
              trailing: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () => pickTime(context),
              ),
            ),
            ElevatedButton(
              onPressed: saveDevice,
              child: Text(selectedIndex == null ? 'Salvar' : 'Atualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
