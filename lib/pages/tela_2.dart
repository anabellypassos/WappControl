import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Tela2 extends StatefulWidget {
  @override
  Tela2State createState() => Tela2State();
}

class Tela2State extends State<Tela2> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController powerController = TextEditingController();
  final TextEditingController daysUsedController = TextEditingController();

  TimeOfDay? selectedTime;
  String selectedTimeFormatted = "00:00";

  String selectedCategory = 'Cozinha';
  String selectedDevice = '';
  int? selectedIndex;

  final List<String> predefinedDevicesList = [
    'Televisão: 100W',
    'Micro-ondas: 1100W',
    'Chuveiro elétrico: 5500W',
    'Notebook: 60W',
    'Carregador de celular: 5W',
    'Liquidificador: 350W',
    'Cafeteira elétrica: 800W',
    'Fogão elétrico: 1500W',
    'Lâmpadas (LED): 10W por lâmpada',
    'Ar-condicionado: 1200W',
    'Ventilador: 70W',
    'Chapinha: 60W',
    'Secador de cabelo: 2000W',
  ];

  final List<String> categories = [
    'Cozinha',
    'Iluminação',
    'Entretenimento',
    'Beleza',
    'Outros'
  ];

  @override
  void initState() {
    super.initState();
    fetchDevices();
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        selectedTimeFormatted =
            '${picked.hour}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> saveDevice() async {
    final String name = nameController.text;
    final int? power = int.tryParse(powerController.text);
    final int? daysUsed = int.tryParse(daysUsedController.text);

    if (name.isNotEmpty &&
        power != null &&
        selectedCategory.isNotEmpty &&
        selectedTime != null &&
        daysUsed != null) {
      final double totalHours =
          selectedTime!.hour + (selectedTime!.minute / 60);
      final double totalMinutes = totalHours * 60;

      final device = {
        'name': name,
        'power': power,
        'category': selectedCategory,
        'usage': totalHours,
        'usageInMinutes': totalMinutes,
        'daysUsed': daysUsed,
      };

      try {
        if (selectedIndex == null) {
          // Adicionar um novo dispositivo
          await FirebaseFirestore.instance.collection('devices').add(device);
        } else {
          // Atualizar um dispositivo existente
          final docRef = FirebaseFirestore.instance
              .collection('devices')
              .doc(predefinedDevices[selectedIndex!]['id']);

          await docRef.update(device);
        }

        // Atualiza a lista de dispositivos e limpa o formulário
        await fetchDevices();
        _resetForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar dispositivo: $e')),
        );
      }
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
    selectedDevice = '';
    selectedIndex = null;
    selectedTime = null;
  }

  Future<void> fetchDevices() async {
    final snapshot = await FirebaseFirestore.instance.collection('devices').get();

    setState(() {
      predefinedDevices = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['name'],
                'power': doc['power'],
                'category': doc['category'],
                'usage': doc['usage'],
                'usageInMinutes': doc['usageInMinutes'],
                'daysUsed': doc['daysUsed'],
              })
          .toList();
    });
  }

  void editDevice(int index) {
    final device = predefinedDevices[index];
    nameController.text = device['name'];
    powerController.text = device['power'].toString();
    daysUsedController.text = device['daysUsed'].toString();
    selectedCategory = device['category'];
    selectedDevice = '${device['name']}: ${device['power']}W';
    selectedTimeFormatted = _formatTimeFromHours(device['usage']);
    selectedIndex = index;
  }

  String _formatTimeFromHours(double hours) {
    final int totalMinutes = (hours * 60).toInt();
    final int hoursPart = totalMinutes ~/ 60;
    final int minutesPart = totalMinutes % 60;
    return '${hoursPart.toString().padLeft(2, '0')}:${minutesPart.toString().padLeft(2, '0')}';
  }

  void deleteDevice(int index) async {
    final deviceId = predefinedDevices[index]['id'];
    try {
      await FirebaseFirestore.instance.collection('devices').doc(deviceId).delete();
      setState(() {
        predefinedDevices.removeAt(index);
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir dispositivo: $e')),
      );
    }
  }

  List<Map<String, dynamic>> predefinedDevices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 98, 104),
        title: const Text(
          'Cadastro de Dispositivos',
          style: TextStyle(color: Color.fromARGB(255, 233, 196, 30)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Cadastro de Dispositivos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedDevice.isEmpty ? null : selectedDevice,
                hint: const Text('Selecione um dispositivo'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDevice = newValue!;
                    final deviceParts = selectedDevice.split(':');
                    nameController.text = deviceParts[0].trim();
                    powerController.text = deviceParts[1].trim().replaceAll('W', '');
                  });
                },
                items: predefinedDevicesList.map((String device) {
                  return DropdownMenuItem<String>(
                    value: device,
                    child: Text(device),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: powerController,
                decoration: const InputDecoration(
                  labelText: 'Potência (W)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: daysUsedController,
                decoration: const InputDecoration(
                  labelText: 'Dias Usados',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickTime(context),
                      child: const Text('Selecionar Hora'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(selectedTimeFormatted),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveDevice,
                child: Text(selectedIndex == null ? 'Salvar' : 'Atualizar'),
              ),
              const SizedBox(height: 20),
              Text(
                'Dispositivos Cadastrados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: predefinedDevices.length,
                itemBuilder: (context, index) {
                  final device = predefinedDevices[index];
                  return ListTile(
                    title: Text('${device['name']} (${device['power']}W)'),
                    subtitle: Text('Categoria: ${device['category']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
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
            ],
          ),
        ),
      ),
    );
  }
}
