abstract class CalculatorState {}

class CalculatorInitial extends CalculatorState {}
class Calculating extends CalculatorState {}
class Calculated extends CalculatorState {
  final String result;
  Calculated({required this.result});
}
class ErrorState extends CalculatorState {
  final String message;
  ErrorState({required this.message});
}
