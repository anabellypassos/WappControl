import 'package:flutter/material.dart';

class Tela2 extends StatefulWidget {
  const Tela2({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Tela2State createState() => _Tela2State();
}

class _Tela2State extends State<Tela2> {
  final List<Map<String, dynamic>> predefinedDevices = [
    {'name': 'Micro-ondas', 'power': 1100, 'category': 'Cozinha'},
    {'name': 'Geladeira', 'power': 150, 'category': 'Cozinha'},
    {'name': 'Televisão', 'power': 100, 'category': 'Entretenimento'},
    // Adicione mais dispositivos conforme necessário
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController powerController = TextEditingController();
  String selectedCategory = 'Cozinha';
  int? selectedIndex;

  final List<String> categories = ['Cozinha', 'Iluminação', 'Entretenimento', 'Beleza','Outros'];

  void saveDevice() {
    final String name = nameController.text;
    final int? power = int.tryParse(powerController.text);

    if (name.isNotEmpty && power != null && selectedCategory.isNotEmpty) {
      setState(() {
        if (selectedIndex == null) {
          predefinedDevices.add({'name': name, 'power': power, 'category': selectedCategory});
        } else {
          predefinedDevices[selectedIndex!] = {'name': name, 'power': power, 'category': selectedCategory};
        }
      });

      nameController.clear();
      powerController.clear();
      selectedCategory = categories[0];
      selectedIndex = null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dispositivo salvo com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
    }
  }

  void editDevice(int index) {
    final device = predefinedDevices[index];
    nameController.text = device['name'];
    powerController.text = device['power'].toString();
    selectedCategory = device['category'];
    selectedIndex = index;
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
        title: const Text('Cadastro de Dispositivos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dispositivos Pré-definidos:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: predefinedDevices.length,
                itemBuilder: (context, index) {
                  final device = predefinedDevices[index];
                  return ListTile(
                    title: Text('${device['name']} - ${device['power']}W'),
                    subtitle: Text('Categoria: ${device['category']}'),
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
