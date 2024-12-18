import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/calculation.dart';
import '../blocs/HistoryBloc/historyBloc.dart';
import '../blocs/calculator_bloc/calculator_bloc.dart';
import '../blocs/calculator_bloc/calculator_event.dart';
import '../blocs/calculator_bloc/calculator_state.dart';
import '../../core/theme/theme_bloc.dart';
import '../widgets/calculator_button.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _currentExpression = "";
  bool _showHistory = false;
  String _selectedFilter = 'All'; 
  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        
        _currentExpression = '';
        context.read<CalculatorBloc>().emit(CalculatorInitial());
      } else if (value == '=') {
        
        if (isValidOperation(_currentExpression)) {
          
          final originalExpression = _currentExpression;

          
          final result = context
              .read<CalculatorBloc>()
              .calculateExpression
              .execute(originalExpression);

          if (!result.startsWith('Error')) {
            
            context
                .read<CalculatorBloc>()
                .add(AddExpression(originalExpression, result));
            _currentExpression = result;

            
            if (_showHistory) {
              context.read<HistoryBloc>().add(LoadHistoryEvent());
            }
          } else {
            
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 40),
                      SizedBox(height: 8),
                      Text(
                        result,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        } else {
          
          _currentExpression = 'Invalid Expression';
        }
      } else {
        
        if (_currentExpression == 'Invalid Expression') {
          _currentExpression = '';
        }

        
        _currentExpression += value;

        
        if (isValidOperation(_currentExpression)) {
          final liveResult = context
              .read<CalculatorBloc>()
              .calculateExpression
              .execute(_currentExpression);
          if (!liveResult.startsWith('Error')) {
            context.read<CalculatorBloc>().emit(Calculated(result: liveResult));
          } else {
            context.read<CalculatorBloc>().emit(CalculatorInitial());
          }
        } else {
          context.read<CalculatorBloc>().emit(CalculatorInitial());
        }
      }
    });
  }

  void _clearHistory() {
    context.read<HistoryBloc>().clearHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 5, 
        title: Text(
          'Calculator',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.headline6?.color,
            shadows: [
              Shadow(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black26
                    : Colors.white24,
                offset: Offset(1, 1),
                blurRadius: 3,
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.brightness_6,
              color: Theme.of(context).iconTheme.color,
              size: 28, 
              shadows: [
                Shadow(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black26
                      : Colors.white24,
                  offset: Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleThemeEvent());
            },
            tooltip: "Toggle Light/Dark Mode", 
          ),
        ],
      ),
      body: Stack(
        children: [
          
          Column(
            children: [
              
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(20.0),
                  color: Colors.black12,
                  child: Text(
                    _currentExpression,
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(_showHistory ? Icons.close : Icons.history),
                      onPressed: () {
                        setState(() {
                          _showHistory =
                              !_showHistory; 
                          if (_showHistory) {
                            context.read<HistoryBloc>().add(LoadHistoryEvent());
                            
                          }
                        });
                      },
                    ),
                    
                    Expanded(
                      child: BlocBuilder<CalculatorBloc, CalculatorState>(
                        builder: (context, state) {
                          if (state is Calculated) {
                            return Container(
                              padding: EdgeInsets.all(20),
                              alignment: Alignment.bottomRight,
                              child: RichText(
                                textAlign: TextAlign
                                    .right, 
                                text: TextSpan(
                                  text: 'Result: ', 
                                  style: TextStyle(
                                    fontSize:
                                        20, 
                                    fontWeight: FontWeight.normal,
                                    color: Colors
                                        .grey, 
                                  ),
                                  children: [
                                    TextSpan(
                                      text: state
                                          .result, 
                                      style: TextStyle(
                                        fontSize:
                                            32, 
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: 16,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final buttons = [
                        '7',
                        '8',
                        '9',
                        '/',
                        '4',
                        '5',
                        '6',
                        '*',
                        '1',
                        '2',
                        '3',
                        '-',
                        'C',
                        '0',
                        '=',
                        '+',
                      ];
                      return CalculatorButton(
                        label: buttons[index],
                        onPressed: () => _onButtonPressed(buttons[index]),
                        color: buttons[index] == '='
                            ? Colors.orange
                            : buttons[index] == 'C'
                                ? Colors.red
                                : Colors.blueGrey,
                      );
                    },
                  ),
                ),
              ),
              
            ],
          ),
          
          if (_showHistory)
            
            DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.3,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                final cardColor = Theme.of(context).cardColor;
                final textColor =
                    Theme.of(context).textTheme.bodyText1?.color ??
                        Colors.black;
                final dividerColor = Theme.of(context).dividerColor;

                return Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, -2),
                        blurRadius: 10,
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: Theme.of(context).brightness == Brightness.light
                          ? [Colors.white, Colors.grey[200]!]
                          : [Colors.grey[900]!, Colors.grey[800]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: Text(
                                "History",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: textColor,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _showHistory ? Icons.close : Icons.history,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showHistory =
                                          !_showHistory; 
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                          thickness: 1, color: dividerColor.withOpacity(0.8)),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Filter by:",
                              style: TextStyle(
                                fontSize: 16,
                                color: textColor.withOpacity(0.8),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: cardColor.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: dividerColor.withOpacity(0.5)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    value: _selectedFilter,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'All',
                                        child: Row(
                                          children: [
                                            Icon(Icons.all_inclusive,
                                                color: textColor, size: 18),
                                            SizedBox(width: 8),
                                            Text("All"),
                                          ],
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Addition',
                                        child: Row(
                                          children: [
                                            Icon(Icons.add,
                                                color: textColor, size: 18),
                                            SizedBox(width: 8),
                                            Text("Addition"),
                                          ],
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Subtraction',
                                        child: Row(
                                          children: [
                                            Icon(Icons.remove,
                                                color: textColor, size: 18),
                                            SizedBox(width: 8),
                                            Text("Subtraction"),
                                          ],
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Multiplication',
                                        child: Row(
                                          children: [
                                            Icon(Icons.close,
                                                color: textColor, size: 18),
                                            SizedBox(width: 8),
                                            Text("Multiplication"),
                                          ],
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Division',
                                        child: Row(
                                          children: [
                                            Icon(Icons.percent,
                                                color: textColor, size: 18),
                                            SizedBox(width: 8),
                                            Text("Division"),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedFilter = value!;
                                        context
                                            .read<HistoryBloc>()
                                            .add(FilterHistoryEvent(value));
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Icon(
                            Icons
                                .clear_all_outlined, 
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _clearHistory(); 
                          },
                        ),
                      ),
                      
                      Expanded(
                        child: BlocBuilder<HistoryBloc, List<Calculation>>(
                          builder: (context, history) {
                            if (history.isEmpty) {
                              return Center(
                                child: Text(
                                  "No history available",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor.withOpacity(0.6),
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              controller: scrollController,
                              itemCount: history.length,
                              itemBuilder: (context, index) {
                                final calculation = history[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 4.0),
                                  elevation: 2,
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            calculation.expression,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "=",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: textColor.withOpacity(0.7),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          calculation.result,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
