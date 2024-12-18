import 'package:hive/hive.dart';
import '../models/calculation_model.dart';
import '../../domain/entities/calculation.dart';
import '../../domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final Box<CalculationModel> _historyBox;

  HistoryRepositoryImpl(this._historyBox);

  @override
  void saveCalculation(String expression, String result) {
    _historyBox.add(CalculationModel(expression, result));
  }

  @override
  List<Calculation> getHistory() {
    return _historyBox.values
        .map((model) => Calculation(model.expression, model.result))
        .toList();
  }

  @override
  void clearHistory() => _historyBox.clear();
}
