import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const CalculatorButton({
    required this.label,
    required this.onPressed,
    this.color = Colors.blueGrey, 
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color, 
        padding: EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}
