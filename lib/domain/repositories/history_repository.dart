import '../entities/calculation.dart';

abstract class HistoryRepository {
  void saveCalculation(String expression, String result);
  List<Calculation> getHistory(); 
  void clearHistory();
}
