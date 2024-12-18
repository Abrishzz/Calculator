import 'package:hive/hive.dart';

part 'calculation_model.g.dart';

@HiveType(typeId: 0)
class CalculationModel {
  @HiveField(0)
  final String expression;  
  @HiveField(1)
  final String result;     

  CalculationModel(this.expression, this.result);

  @override
  String toString() => 'Expression: $expression, Result: $result';
}
