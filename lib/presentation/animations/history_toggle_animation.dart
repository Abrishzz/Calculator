import 'package:flutter/material.dart';

class HistoryToggleAnimation extends StatelessWidget {
  final bool showHistory;
  final Widget child;

  const HistoryToggleAnimation({required this.showHistory, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: showHistory ? child : SizedBox.shrink(),
    );
  }
}

