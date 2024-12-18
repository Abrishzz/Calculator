import '../entities/calculation.dart';
import '../repositories/history_repository.dart';

class ManageHistory {
  final HistoryRepository repository;

  ManageHistory(this.repository);

  void saveCalculation(String expression, String result) {
    repository.saveCalculation(expression, result);
  }

  List<Calculation> getHistory() => repository.getHistory();

  void clearHistory() => repository.clearHistory();
}