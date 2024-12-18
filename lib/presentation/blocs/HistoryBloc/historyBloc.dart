import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/calculation.dart';
import '../../../domain/use_cases/manage_history.dart';


abstract class HistoryEvent {}

class LoadHistoryEvent extends HistoryEvent {}

class FilterHistoryEvent extends HistoryEvent {
  final String filter;
  FilterHistoryEvent(this.filter);
}
class HistoryBloc extends Bloc<HistoryEvent, List<Calculation>> {
  final ManageHistory manageHistory;

  HistoryBloc(this.manageHistory) : super([]) {
    on<LoadHistoryEvent>((event, emit) {
      final history = manageHistory.getHistory();
      print("Loading all history: ${history.map((c) => 'Expression: ${c.expression}, Result: ${c.result}').toList()}");
      emit(history);
    });

    on<FilterHistoryEvent>((event, emit) {
      final history = manageHistory.getHistory();
      print("Current filter: ${event.filter}");
      
      List<Calculation> filteredHistory;
      if (event.filter == 'All') {
        filteredHistory = history;
      } else {
        filteredHistory = history.where((calc) {
          final expression = calc.expression; 
          print("Checking expression for ${event.filter}: $expression");
          
          switch (event.filter) {
            case 'Addition':
              return expression.contains('+');
            case 'Subtraction':
              if (expression.startsWith('-')) {
                return expression.substring(1).contains('-');
              }
              return expression.contains('-');
            case 'Multiplication':
              return expression.contains('*');
            case 'Division':
              return expression.contains('/');
            default:
              return false;
          }
        }).toList();
      }
      
      print("Filtered results: ${filteredHistory.map((c) => c.expression).toList()}");
      emit(filteredHistory);
    });
  }

  void clearHistory() {
    manageHistory.clearHistory();
    add(LoadHistoryEvent());
  }
}