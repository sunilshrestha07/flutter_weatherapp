import 'package:flutter/material.dart';

class Forcastwidget extends StatelessWidget {
  final String time;
  final String icon;
  final String temp;
  const Forcastwidget({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: 140,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 49, 48, 48),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500), time),
          SizedBox(height: 4),
          Icon(
            size: 35,
            icon == "Rain"
                ? Icons.cloudy_snowing
                : icon == "Clear"
                ? Icons.sunny
                : Icons.cloud,
          ),
          SizedBox(height: 4),
          Text(style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400), temp),
        ],
      ),
    );
  }
}
