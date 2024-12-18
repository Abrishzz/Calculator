abstract class CalculatorEvent {}

class AddExpression extends CalculatorEvent {
  final String expression;
  final String result;
  AddExpression(this.expression, this.result);
}

class ClearHistory extends CalculatorEvent {}
