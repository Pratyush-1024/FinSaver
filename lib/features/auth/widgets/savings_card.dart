import 'package:flutter/material.dart';

Widget buildSavingsCard(
  BuildContext context,
  String name,
  String type,
  List<Color> colors,
  double savingsAmount, // Add savingsAmount parameter
) {
  return Padding(
    padding: const EdgeInsets.only(right: 16.0),
    child: Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 360,
        height: 220,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Positioned(
              top: 16,
              right: 16,
              child: Icon(
                Icons.savings,
                color: Colors.white,
                size: 30,
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                type,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 16,
              child: Text(
                '₹${savingsAmount.toStringAsFixed(2)}', // Display savingsAmount
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 16,
              child: Container(
                width: 150,
                height: 2,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            Positioned(
              top: 100,
              right: 16,
              child: Container(
                width: 100,
                height: 2,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
