
import 'package:math_expressions/math_expressions.dart';

class CalculateExpression {
  String execute(String expression) {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel contextModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, contextModel);
      if (eval.isInfinite || eval.isNaN) {
        throw Exception('Cannot divide by zero');
      }
      return eval.toString();
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}

