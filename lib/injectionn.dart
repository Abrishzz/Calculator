// # Fully Functional Code for the Calculator App

// # 1. core/constants/app_constants.dart
// const String appTitle = 'Calculator App';

// # 2. core/theme/app_theme.dart
// import 'package:flutter/material.dart';

// final ThemeData lightTheme = ThemeData.light();
// final ThemeData darkTheme = ThemeData.dark();

// # 3. core/theme/theme_config.dart
// import 'package:flutter/material.dart';

// class ThemeConfig extends ChangeNotifier {
//   ThemeMode _themeMode = ThemeMode.light;

//   ThemeMode get themeMode => _themeMode;

//   void toggleTheme() {
//     _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//   }
// }


// # 4. core/utils/validators.dart
// bool isValidOperation(String expression) {
//   return RegExp(r'^-?(\d+|\d+\.\d+)([+\-*/]-?(\d+|\d+\.\d+))*$').hasMatch(expression) &&
//          !RegExp(r'/0').hasMatch(expression); // Prevents division by zero
// }



// # 5. data/models/calculation_model.dart
// import 'package:hive/hive.dart';

// part 'calculation_model.g.dart';

// @HiveType(typeId: 0)
// class CalculationModel {
//   @HiveField(0)
//   final String expression;
//   @HiveField(1)
//   final String result;

//   CalculationModel(this.expression, this.result);
// }

// # Run the following command to generate the adapter:
// # flutter packages pub run build_runner build

// # 6. data/repositories/history_repository.dart
// import 'package:hive/hive.dart';
// import '../models/calculation_model.dart';
// import '../../domain/entities/calculation.dart';
// import '../../domain/repositories/history_repository.dart';

// class HistoryRepositoryImpl implements HistoryRepository {
//   final Box<CalculationModel> _historyBox;

//   HistoryRepositoryImpl(this._historyBox);

//   @override
//   void saveCalculation(String expression, String result) {
//     _historyBox.add(CalculationModel(expression, result));
//   }

//   @override
//   List<Calculation> getHistory() {
//     return _historyBox.values
//         .map((model) => Calculation(model.expression, model.result))
//         .toList();
//   }

//   @override
//   void clearHistory() => _historyBox.clear();
// }


// # 7. data/data_providers/local_storage.dart
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import '../models/calculation_model.dart';

// Future<void> initLocalStorage() async {
//   await Hive.initFlutter();
//   Hive.registerAdapter(CalculationModelAdapter());
//   await Hive.openBox<CalculationModel>('calculation_history');
// }

// Box<CalculationModel> getHistoryBox() => Hive.box('calculation_history');

// # 8. domain/entities/calculation.dart
// class Calculation {
//   final String expression;
//   final String result;

//   Calculation(this.expression, this.result);
// }

// # 9. domain/repositories/history_repository.dart
// import '../entities/calculation.dart';

// abstract class HistoryRepository {
//   void saveCalculation(String expression, String result);
//   List<Calculation> getHistory(); // Return type as Calculation
//   void clearHistory();
// }


// # 10. domain/use_cases/calculate_expression.dart
// import 'package:math_expressions/math_expressions.dart';

// import 'package:math_expressions/math_expressions.dart';

// class CalculateExpression {
//   String execute(String expression) {
//     try {
//       Parser parser = Parser();
//       Expression exp = parser.parse(expression);
//       ContextModel contextModel = ContextModel();
//       double eval = exp.evaluate(EvaluationType.REAL, contextModel);
//       if (eval.isInfinite || eval.isNaN) {
//         return 'Error: Invalid operation';
//       }
//       return eval.toString();
//     } catch (e) {
//       return 'Error: Malformed expression';
//     }
//   }





//   num _evaluate(String expression) {
//     // Add logic for basic calculator operations
//     if (expression.contains('/')) {
//       var parts = expression.split('/');
//       if (parts.length == 2 && parts[1] == '0') {
//         throw ArgumentError('Cannot divide by zero');
//       }
//     }
    
//     // Simplified eval (can be improved with proper parsing for more complex cases)
//     final result = _evaluateSimple(expression);
//     return result;
//   }

//   num _evaluateSimple(String expression) {
//     // This is a basic implementation; you can replace this with a proper library for complex expressions
//     try {
//       return double.parse(expression);  // For basic expression, just returning the parsed value
//     } catch (e) {
//       throw FormatException('Invalid expression');
//     }
//   }
// }




//   num _evaluate(String expression) {
//     // Add logic for basic calculator operations
//     if (expression.contains('/')) {
//       var parts = expression.split('/');
//       if (parts.length == 2 && parts[1] == '0') {
//         throw ArgumentError('Cannot divide by zero');
//       }
//     }
    
//     // Simplified eval (can be improved with proper parsing for more complex cases)
//     final result = _evaluateSimple(expression);
//     return result;
//   }

//   num _evaluateSimple(String expression) {
//     // This is a basic implementation; you can replace this with a proper library for complex expressions
//     try {
//       return double.parse(expression);  // For basic expression, just returning the parsed value
//     } catch (e) {
//       throw FormatException('Invalid expression');
//     }
//   }
// }


// # 11. domain/use_cases/manage_history.dart
// import '../repositories/history_repository.dart';
// import '../../data/models/calculation_model.dart';

// class ManageHistory {
//   final HistoryRepository repository;

//   ManageHistory(this.repository);

//   void saveCalculation(String expression, String result) {
//     repository.saveCalculation(expression, result);
//   }

//   List<CalculationModel> getHistory() => repository.getHistory();

//   void clearHistory() => repository.clearHistory();
// }

// # 12. presentation/blocs/calculator_bloc/calculator_bloc.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'calculator_event.dart';
// import 'calculator_state.dart';
// import '../../../domain/use_cases/calculate_expression.dart';
// import '../../../domain/use_cases/manage_history.dart';

// class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
//   final CalculateExpression calculateExpression;
//   final ManageHistory manageHistory;

//   CalculatorBloc(this.calculateExpression, this.manageHistory) : super(CalculatorInitial()) {
//     on<AddExpression>(_onAddExpression);
//     on<ClearHistory>(_onClearHistory);
//   }

// void _onAddExpression(AddExpression event, Emitter<CalculatorState> emit) {
//   try {
//     final result = calculateExpression.execute(event.expression);
//     manageHistory.saveCalculation(event.expression, result); // Save to history
//     emit(Calculated(result: result));
//   } catch (e) {
//     emit(Calculated(result: 'Error'));
//   }
// }

  

//   void _onClearHistory(ClearHistory event, Emitter<CalculatorState> emit) {
//     manageHistory.clearHistory();
//     emit(CalculatorInitial());
//   }
// }




// # 13. presentation/blocs/calculator_bloc/calculator_event.dart
// abstract class CalculatorEvent {}

// class AddExpression extends CalculatorEvent {
//   final String expression;
//   AddExpression(this.expression);
// }

// class ClearHistory extends CalculatorEvent {}

// # 14. presentation/blocs/calculator_bloc/calculator_state.dart
// abstract class CalculatorState {}

// class CalculatorInitial extends CalculatorState {}
// class Calculating extends CalculatorState {}
// class Calculated extends CalculatorState {
//   final String result;
//   Calculated({required this.result});
// }
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../domain/entities/calculation.dart';
// import '../../../domain/use_cases/manage_history.dart';

// // Event class to load and filter history
// abstract class HistoryEvent {}

// class LoadHistoryEvent extends HistoryEvent {}

// class FilterHistoryEvent extends HistoryEvent {
//   final String filter;
//   FilterHistoryEvent(this.filter);
// }

// class HistoryBloc extends Bloc<HistoryEvent, List<Calculation>> {
//   final ManageHistory manageHistory;

//   HistoryBloc(this.manageHistory) : super([]) {
//     on<LoadHistoryEvent>((event, emit) {
//       final history = manageHistory.getHistory();
//       print("Loaded History: $history"); // Debug line
//       emit(history);
//     });

//  on<FilterHistoryEvent>((event, emit) {
//   final history = manageHistory.getHistory();
//   List<Calculation> filteredHistory = [];

//   print("Filtering history for: ${event.filter}");

//   if (event.filter == 'All') {
//     filteredHistory = history;
//   } else {
//     filteredHistory = history.where((calc) {
//       print("Checking expression: ${calc.expression}");
//       if (event.filter == 'Addition') return calc.expression.contains('+');
//       if (event.filter == 'Subtraction') return calc.expression.contains('-');
//       if (event.filter == 'Multiplication') return calc.expression.contains('*');
//       if (event.filter == 'Division') return calc.expression.contains('/');
//       return false;
//     }).toList();
//   }

//   emit(filteredHistory);
// });

//   }

//   void clearHistory() {
//     manageHistory.clearHistory();
//     print("History cleared"); // Debug line
//     add(LoadHistoryEvent()); // Reload the history
//   }
// }


// # 15. presentation/screens/calculator_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../core/utils/validators.dart';
// import '../../domain/entities/calculation.dart';
// import '../blocs/HistoryBloc/historyBloc.dart';
// import '../blocs/calculator_bloc/calculator_bloc.dart';
// import '../blocs/calculator_bloc/calculator_event.dart';
// import '../blocs/calculator_bloc/calculator_state.dart';
// import '../../core/theme/theme_bloc.dart';
// import '../widgets/calculator_button.dart';

// class CalculatorScreen extends StatefulWidget {
//   @override
//   _CalculatorScreenState createState() => _CalculatorScreenState();
// }

// class _CalculatorScreenState extends State<CalculatorScreen> {
//   String _currentExpression = "";
//   bool _showHistory = false;
//   String _selectedFilter = 'All'; // For filtering history
// void _onButtonPressed(String value) {
//   setState(() {
//     if (value == 'C') {
//       // Clear the current expression
//       _currentExpression = '';
//       context.read<CalculatorBloc>().emit(CalculatorInitial());
//     } 
//     else if (value == '=') {
//       // Check if the current expression is valid
//       if (isValidOperation(_currentExpression)) {
//         // Perform the calculation and show the result
//         final result = context.read<CalculatorBloc>().calculateExpression.execute(_currentExpression);
//         if (result.startsWith('Error')) {
//           // Show error bottom sheet for invalid operations
//           showModalBottomSheet(
//             context: context,
//             builder: (BuildContext context) {
//               return Container(
//                 padding: EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).cardColor,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.error, color: Colors.red, size: 40),
//                     SizedBox(height: 8),
//                     Text(
//                       result,
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: Text('OK'),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         } else {
//           // Update the expression to the calculated result
//           _currentExpression = result;
//           context.read<CalculatorBloc>().add(AddExpression(_currentExpression));
//         }
//       } else {
//         // Invalid expression; ignore or show feedback if needed
//         _currentExpression = 'Invalid Expression';
//       }
//     } 
//     else {
//       // If the current expression is "Invalid Expression", reset it
//       if (_currentExpression == 'Invalid Expression') {
//         _currentExpression = '';
//       }

//       // Append input to the expression
//       _currentExpression += value;

//       // If the input forms a valid operation, show the live result
//       if (isValidOperation(_currentExpression)) {
//         final result = context.read<CalculatorBloc>().calculateExpression.execute(_currentExpression);
//         context.read<CalculatorBloc>().emit(Calculated(result: result));
//       } else {
//         // Clear live result if the expression is invalid
//         context.read<CalculatorBloc>().emit(CalculatorInitial());
//       }
//     }
//   });
// }

//  void _clearHistory() {
//     context.read<HistoryBloc>().clearHistory();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//      appBar: AppBar(
//   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//   elevation: 5, // Add slight elevation for a shadow effect
//   title: Text(
//     'Calculator',
//     style: TextStyle(
//       fontSize: 24,
//       fontWeight: FontWeight.bold,
//       color: Theme.of(context).textTheme.headline6?.color,
//       shadows: [
//         Shadow(
//           color: Theme.of(context).brightness == Brightness.light
//               ? Colors.black26
//               : Colors.white24,
//           offset: Offset(1, 1),
//           blurRadius: 3,
//         ),
//       ],
//     ),
//   ),
//   centerTitle: true,
//   actions: [
//     IconButton(
//       icon: Icon(
//         Icons.brightness_6,
//         color: Theme.of(context).iconTheme.color,
//         size: 28, // Slightly larger icon for better visibility
//         shadows: [
//           Shadow(
//             color: Theme.of(context).brightness == Brightness.light
//                 ? Colors.black26
//                 : Colors.white24,
//             offset: Offset(1, 1),
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       onPressed: () {
//         context.read<ThemeBloc>().add(ToggleThemeEvent());
//       },
//       tooltip: "Toggle Light/Dark Mode", // Accessibility improvement
//     ),
//   ],
// ),

//       body: Stack(
//         children: [
//           // Main Calculator Layout
//           Column(
//             children: [
//               // Display Expression
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   alignment: Alignment.bottomRight,
//                   padding: EdgeInsets.all(20.0),
//                   color: Colors.black12,
//                   child: Text(
//                     _currentExpression,
//                     style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(children: [
//                    IconButton(
//                   icon: Icon(_showHistory ? Icons.close : Icons.history),
//                   onPressed: () {
//                     setState(() {
//                       _showHistory = !_showHistory; // Toggle the history view
//                       if (_showHistory) {
//                         context.read<HistoryBloc>().add(LoadHistoryEvent());
//  // Load history when toggled on
//                       }
//                     });
//                   },
//                 ),
//                   // Display Result
//                 Expanded(
//                   child: BlocBuilder<CalculatorBloc, CalculatorState>(
//                     builder: (context, state) {
//                       if (state is Calculated) {
//                         return Container(
//   padding: EdgeInsets.all(20),
//   alignment: Alignment.bottomRight,
//   child: RichText(
//     textAlign: TextAlign.right, // Aligns the text to the right
//     text: TextSpan(
//       text: 'Result: ', // The label part
//       style: TextStyle(
//         fontSize: 20, // Smaller font size for the label
//         fontWeight: FontWeight.normal,
//         color: Colors.grey, // Optional: Different color for label
//       ),
//       children: [
//         TextSpan(
//           text: state.result, // The actual result part
//           style: TextStyle(
//             fontSize: 32, // Larger font size for the result
//             fontWeight: FontWeight.bold,
//             color: Colors.green,
//           ),
//         ),
//       ],
//     ),
//   ),
// );

//                       }
//                       return SizedBox.shrink();
//                     },
//                   ),
//                 ),
//                 ],),
//               ),
            
//               // Buttons Grid
//               Expanded(
//                 flex: 5,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GridView.builder(
//                     itemCount: 16,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 4,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                     ),
//                     itemBuilder: (context, index) {
//                       final buttons = [
//                         '7',
//                         '8',
//                         '9',
//                         '/',
//                         '4',
//                         '5',
//                         '6',
//                         '*',
//                         '1',
//                         '2',
//                         '3',
//                         '-',
//                         'C',
//                         '0',
//                         '=',
//                         '+',
//                       ];
//                       return CalculatorButton(
//                         label: buttons[index],
//                         onPressed: () => _onButtonPressed(buttons[index]),
//                         color: buttons[index] == '='
//                             ? Colors.orange
//                             : buttons[index] == 'C'
//                                 ? Colors.red
//                                 : Colors.blueGrey,
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               // History Toggle Button
             
//             ],
//           ),
//           // DraggableScrollableSheet for History
//           if (_showHistory)
//     // Add this inside the DraggableScrollableSheet builder
// DraggableScrollableSheet(
//   initialChildSize: 0.7,
//   minChildSize: 0.3,
//   maxChildSize: 0.8,
//   builder: (context, scrollController) {
//     // Determine colors based on theme
//     final cardColor = Theme.of(context).cardColor;
//     final textColor = Theme.of(context).textTheme.bodyText1?.color ?? Colors.black;
//     final dividerColor = Theme.of(context).dividerColor;

//     return Container(
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             offset: Offset(0, -2),
//             blurRadius: 10,
//           ),
//         ],
//         gradient: LinearGradient(
//           colors: Theme.of(context).brightness == Brightness.light
//               ? [Colors.white, Colors.grey[200]!]
//               : [Colors.grey[900]!, Colors.grey[800]!],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header Section
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Center(
//                   child: Text(
//                     "History",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: textColor,
//                     ),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         _showHistory ? Icons.close : Icons.history,
//                         color: Colors.red,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _showHistory = !_showHistory; // Toggle history view
//                         });
//                       },
//                     ),
                  
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Divider(thickness: 1, color: dividerColor.withOpacity(0.8)),
//           // Filter Dropdown
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
               
//                 Text(
//                   "Filter by:",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: textColor.withOpacity(0.8),
//                   ),
//                 ),
//                   Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10.0),
//                   decoration: BoxDecoration(
//                 color: cardColor.withOpacity(0.9),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: dividerColor.withOpacity(0.5)),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                 child:// Inside your build method, under the DropdownButton widget
// DropdownButton<String>(
//   value: _selectedFilter,
//   items: [
//     DropdownMenuItem(
//       value: 'All',
//       child: Row(
//         children: [
//           Icon(Icons.all_inclusive, color: textColor, size: 18),
//           SizedBox(width: 8),
//           Text("All"),
//         ],
//       ),
//     ),
//     DropdownMenuItem(
//       value: 'Addition',
//       child: Row(
//         children: [
//           Icon(Icons.add, color: textColor, size: 18),
//           SizedBox(width: 8),
//           Text("Addition"),
//         ],
//       ),
//     ),
//     DropdownMenuItem(
//       value: 'Subtraction',
//       child: Row(
//         children: [
//           Icon(Icons.remove, color: textColor, size: 18),
//           SizedBox(width: 8),
//           Text("Subtraction"),
//         ],
//       ),
//     ),
//     DropdownMenuItem(
//       value: 'Multiplication',
//       child: Row(
//         children: [
//           Icon(Icons.close, color: textColor, size: 18),
//           SizedBox(width: 8),
//           Text("Multiplication"),
//         ],
//       ),
//     ),
//     DropdownMenuItem(
//       value: 'Division',
//       child: Row(
//         children: [
//           Icon(Icons.percent, color: textColor, size: 18),
//           SizedBox(width: 8),
//           Text("Division"),
//         ],
//       ),
//     ),
//   ],
//  onChanged: (value) {
//     print("Selected filter: $value"); // Debug line
//     setState(() {
//       _selectedFilter = value!;
//     });
//     context.read<HistoryBloc>().add(FilterHistoryEvent(_selectedFilter));
//   },
// ),


//                   ),
//                 ),
              
//               ],
//             ),
//           ),
//           SizedBox(height: 8),
//              Align(
//               alignment: Alignment.bottomRight,
//                child: IconButton(
//                         icon: Icon(
//                           Icons.clear_all_outlined, // Trash can icon for clearing history
//                           color: Colors.red,
//                         ),
//                         onPressed: () {
//                           _clearHistory(); // Call the clear history function
//                         },
//                       ),
//              ),
//           // History List
//           Expanded(
//             child: BlocBuilder<HistoryBloc, List<Calculation>>(
//   builder: (context, history) {
//     print("Filtered History: $history");

//     final filteredHistory = history.where((calc) {
//       if (_selectedFilter == 'All') return true;
//       if (_selectedFilter == 'Addition') return calc.expression.contains('+');
//       if (_selectedFilter == 'Subtraction') return calc.expression.contains('-');
//       if (_selectedFilter == 'Multiplication') return calc.expression.contains('*');
//       if (_selectedFilter == 'Division') return calc.expression.contains('/');
//       return false;
//     }).toList();

//     if (filteredHistory.isEmpty) {
//       return Center(
//         child: Text(
//           "No history available",
//           style: TextStyle(
//             fontSize: 14,
//             color: textColor.withOpacity(0.6),
//           ),
//         ),
//       );
//     }
//     return ListView.builder(
//       itemCount: filteredHistory.length,
//       itemBuilder: (context, index) {
//         final item = filteredHistory[index];
//         return Card(
//           child: ListTile(
//             title: Text(item.expression),
//             subtitle: Text("Result: ${item.result}"),
//           ),
//         );
//       },
//     );
//   },
// )

//           ),
//         ],
//       ),
//     );
//   },
// ),



//         ],
//       ),
//     );
//   }
// }





// #16
// import 'package:flutter/material.dart';

// class CalculatorButton extends StatelessWidget {
//   final String label;
//   final Function() onPressed;

//   const CalculatorButton({required this.label, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         padding: EdgeInsets.symmetric(vertical: 20),
//         primary: Colors.blue,
//       ),
//       child: Text(label, style: TextStyle(fontSize: 24)),
//     );
//   }
// }
// #17
// import 'package:flutter/material.dart';

// class HistoryToggleAnimation extends StatelessWidget {
//   final bool showHistory;
//   final Widget child;

//   const HistoryToggleAnimation({required this.showHistory, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//       duration: Duration(milliseconds: 300),
//       child: showHistory ? child : SizedBox.shrink(),
//     );
//   }
// }


// #18 import 'package:flutter/material.dart';
// import 'package:calculator/presentation/blocs/HistoryBloc/historyBloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'core/theme/app_theme.dart';
// import 'core/theme/theme_bloc.dart';
// import 'data/data_providers/local_storage.dart';
// import 'presentation/screens/calculator_screen.dart';
// import 'presentation/blocs/calculator_bloc/calculator_bloc.dart';
// import 'injection.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initLocalStorage();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//   providers: [
//     BlocProvider(create: (_) => ThemeBloc()),
//     BlocProvider(create: (_) => CalculatorBloc(
//       Injection.calculateExpression,
//       Injection.manageHistory,
//     )),
//     BlocProvider(create: (_) => HistoryBloc(Injection.manageHistory)), // Add HistoryBloc
//   ],
//       child: BlocBuilder<ThemeBloc, ThemeState>(
//         builder: (context, themeState) {
//           return MaterialApp(
//             title: 'Calculator App',
//             theme: lightTheme,
//             darkTheme: darkTheme,
//             themeMode: themeState.themeMode,
//             home: CalculatorScreen(),
//           );
//         },
//       ),
//     );
//   }
// }




// #19 
// import 'data/repositories/history_repository.dart';
// import 'domain/use_cases/calculate_expression.dart';
// import 'domain/use_cases/manage_history.dart';

// class Injection {
//   static final HistoryRepository historyRepository = HistoryRepositoryImpl(getHistoryBox());
//   static final CalculateExpression calculateExpression = CalculateExpression();
//   static final ManageHistory manageHistory = ManageHistory(historyRepository);
// }
// #20 import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';

// class ThemeEvent {}
// class ToggleThemeEvent extends ThemeEvent {}

// class ThemeState {
//   final ThemeMode themeMode;
//   ThemeState(this.themeMode);
// }

// class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
//   ThemeBloc() : super(ThemeState(ThemeMode.light)) {
//     on<ToggleThemeEvent>((event, emit) {
//       final newMode = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//       emit(ThemeState(newMode));
//     });
//   }

//   Future<void> _loadThemePreference() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isDarkMode = prefs.getBool('isDarkMode') ?? false;
//     emit(ThemeState(isDarkMode ? ThemeMode.dark : ThemeMode.light));
//   }

//   Future<void> _saveThemePreference(bool isDarkMode) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setBool('isDarkMode', isDarkMode);
//   }

//   @override
//   Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
//     if (event is ToggleThemeEvent) {
//       final newMode = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//       await _saveThemePreference(newMode == ThemeMode.dark);
//       yield ThemeState(newMode);
//     }
//   }
// }

// #21 


// lib/
// ├── core/
// │   ├── constants/
// │   │   └── app_constants.dart        # App-wide constants
// │   ├── theme/
// │   │   ├── app_theme.dart           # Light/Dark mode themes
// │   │   └── theme_config.dart        # Theme configuration
//     |   └── theme_bloc.dart
// │   └── utils/
// │       └── validators.dart          # Utility functions (e.g., input validation)
// ├── data/
// │   ├── models/
// │   │   └── calculation_model.dart   # Hive model for calculation history
// │   ├── repositories/
// │   │   └── history_repository.dart  # Manages CRUD operations for history
// │   └── data_providers/
// │       └── local_storage.dart       # Hive setup and access functions
// ├── domain/
// │   ├── entities/
// │   │   └── calculation.dart         # Core entity for calculations
// │   ├── repositories/
// │   │   └── history_repository.dart  # Abstract repository interface
// │   └── use_cases/
// │       ├── calculate_expression.dart# Business logic for calculations
// │       └── manage_history.dart      # Business logic for history management
// ├── presentation/
// │   ├── blocs/
// │   │   └── calculator_bloc/
// │   │       ├── calculator_bloc.dart # Bloc implementation
// │   │       ├── calculator_event.dart# Events for the Bloc
// │   │       └── calculator_state.dart# States for the Bloc
//     │── HistoryBloc/
// │   │       ├── HistoryBloc.dart 
// │   │     
// │   ├── screens/
// │   │   ├── calculator_screen.dart   # Main calculator UI
// │   │   └── history_screen.dart      # History display UI
// │   ├── widgets/
// │   │   ├── calculator_button.dart   # Reusable button widget
// │   │   ├── result_display.dart      # Display widget for current calculation/result
// │   │   └── history_list.dart        # Widget for showing history
// │   └── animations/
// │       └── history_toggle_animation.dart # Optional animation for toggling history
// ├── main.dart                         # App entry point
// └── injection.dart                    # Dependency injection setup
