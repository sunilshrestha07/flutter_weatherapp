import 'package:flutter/material.dart';

class Additional extends StatelessWidget {
  final String title;
  final String icon;
  final String value;

  const Additional({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(
              size: 35,
              icon == "Air"
                  ? Icons.air
                  : icon == "Humidity"
                  ? Icons.water_drop
                  : Icons.ac_unit,
            ),
            Text(style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500), title),
            Text(style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400), value),
          ],
        ),
      ),
    );
  }
}
