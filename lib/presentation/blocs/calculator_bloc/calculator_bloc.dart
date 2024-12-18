import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';
import '../../../domain/use_cases/calculate_expression.dart';
import '../../../domain/use_cases/manage_history.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final CalculateExpression calculateExpression;
  final ManageHistory manageHistory;

  CalculatorBloc(this.calculateExpression, this.manageHistory) : super(CalculatorInitial()) {
    on<AddExpression>((event, emit) {
      try {
        
        manageHistory.saveCalculation(event.expression, event.result);
        emit(Calculated(result: event.result));
      } catch (e) {
        emit(Calculated(result: 'Error'));
      }
    });
    
    on<ClearHistory>(_onClearHistory);
  }

void _onAddExpression(AddExpression event, Emitter<CalculatorState> emit) {
  try {
    final result = calculateExpression.execute(event.expression);
    if (!result.startsWith('Error')) {
      
      manageHistory.saveCalculation(event.expression, result);
      emit(Calculated(result: result));
    } else {
      emit(Calculated(result: 'Error'));
    }
  } catch (e) {
    emit(Calculated(result: 'Error'));
  }
}

  

  void _onClearHistory(ClearHistory event, Emitter<CalculatorState> emit) {
    manageHistory.clearHistory();
    emit(CalculatorInitial());
  }
}
