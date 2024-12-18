import 'data/data_providers/local_storage.dart';
import 'data/repositories/history_repository.dart';
import 'domain/repositories/history_repository.dart';
import 'domain/use_cases/calculate_expression.dart';
import 'domain/use_cases/manage_history.dart';

class Injection {
  static final HistoryRepository historyRepository = HistoryRepositoryImpl(getHistoryBox());
  static final CalculateExpression calculateExpression = CalculateExpression();
  static final ManageHistory manageHistory = ManageHistory(historyRepository);
}
