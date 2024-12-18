import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/calculation_model.dart';

Future<void> initLocalStorage() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CalculationModelAdapter());
  await Hive.openBox<CalculationModel>('calculation_history');
}

Box<CalculationModel> getHistoryBox() => Hive.box('calculation_history');

