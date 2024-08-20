import 'package:mobx/mobx.dart';

part 'page1_store.g.dart'; // Gerado pelo build_runner

class Page1Store = _Page1StoreBase with _$Page1Store;

abstract class _Page1StoreBase with Store {
  @observable
  String barChartTitle = "Gráfico de Barras (Consumo Mensal)";

  @observable
  String pieChartTitle = "Gráfico de Pizza (Consumo por Categoria)";

  @observable
  String dailySummary = "Resumo Diário:\nTelevisão: 4h\nGeladeira: 24h";

  @action
  void updateBarChartTitle(String newTitle) {
    barChartTitle = newTitle;
  }

  @action
  void updatePieChartTitle(String newTitle) {
    pieChartTitle = newTitle;
  }

  @action
  void updateDailySummary(String newSummary) {
    dailySummary = newSummary;
  }
}
