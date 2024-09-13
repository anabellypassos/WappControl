import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'todoModel.dart';
part 'page1_store.g.dart'; // Arquivo gerado pelo MobX


class Page1Store = _Page1Store with _$Page1Store;

abstract class _Page1Store with Store {
  @observable
  ObservableList<DeviceModel> devices = ObservableList<DeviceModel>();

  @action
  Future<void> fetchDevices() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('devices').get();
      devices.clear(); // Limpa a lista antes de adicionar novos dados

      for (var doc in snapshot.docs) {
        devices.add(DeviceModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      print('Erro ao buscar dispositivos: $e');
    }
  }

  // Método para calcular o consumo mensal para um determinado mês
  double getMonthlyConsumptionForMonth(int month, int year) {
    double totalMonthlyConsumption = 0.0;
    
    for (var device in devices) {
      // Considerar que cada dispositivo tem um método getDailyConsumption
      double dailyConsumption = device.getDailyConsumption();

      // Supondo que todos os dias do mês têm o mesmo uso
      int daysInMonth = DateTime(year, month + 1, 0).day;
      totalMonthlyConsumption += dailyConsumption * daysInMonth;
    }

    return totalMonthlyConsumption;
  }

  // Método para calcular o consumo anual
  double getYearlyConsumption(int year) {
    double totalYearlyConsumption = 0.0;

    // Para cada mês, calcula o consumo mensal
    for (int month = 1; month <= 12; month++) {
      totalYearlyConsumption += getMonthlyConsumptionForMonth(month, year);
    }

    return totalYearlyConsumption;
  }
}