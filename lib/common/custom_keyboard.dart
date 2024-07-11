import 'package:flutter/material.dart';

class CustomKeyboard extends StatelessWidget {
  final Function(String) onKeyTap;

  const CustomKeyboard({super.key, required this.onKeyTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (context, index) {
          String keyLabel;
          if (index < 9) {
            keyLabel = '${index + 1}';
          } else if (index == 9) {
            keyLabel = '.';
          } else if (index == 10) {
            keyLabel = '0';
          } else {
            keyLabel = '<';
          }
          return InkWell(
            onTap: () => onKeyTap(keyLabel),
            child: Container(
              margin:
                  const EdgeInsets.all(2), // Adjust margin to make keys smaller
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ), // Add border
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  keyLabel,
                  style: const TextStyle(
                    fontSize: 27,
                    color: Colors.white,
                  ), // Adjust font size if needed
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
