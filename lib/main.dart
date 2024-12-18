import 'package:calculator/presentation/blocs/HistoryBloc/historyBloc.dart';
import 'package:calculator/presentation/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_bloc.dart';
import 'data/data_providers/local_storage.dart';
import 'presentation/screens/calculator_screen.dart';
import 'presentation/blocs/calculator_bloc/calculator_bloc.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeBloc()..add(LoadThemePreferenceEvent()), 
        ),
        BlocProvider(
          create: (_) => CalculatorBloc(
            Injection.calculateExpression,
            Injection.manageHistory,
          ),
        ),
        BlocProvider(
          create: (_) => HistoryBloc(Injection.manageHistory),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Calculator',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeState.themeMode, 
            home: SplashScreen(),
            routes: {
              '/calculator': (context) => CalculatorScreen(),
            },
          );
        },
      ),
    );
  }
}
