import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weatherapp/additional.dart';
import 'package:weatherapp/forcastwidget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Weatherapphome extends StatefulWidget {
  const Weatherapphome({super.key});

  @override
  State<Weatherapphome> createState() => _WeatherapphomeState();
}

class _WeatherapphomeState extends State<Weatherapphome> {
  dynamic temp = 0;
  String weather = "Rain";
  String weatherIcon = "Rain";
  dynamic time = 0.00;
  dynamic humidityLevel = 91;
  dynamic windSpeed = 7.5;
  dynamic pressureVlaue = 99.9;
  dynamic results;

  // function to fetch data
  Future fetchData() async {
    final uri =
        "http://api.openweathermap.org/data/2.5/forecast?q=Pokhara,np&APPID=2f5981bada075205d9597abf9b490fce";
    final url = Uri.parse(uri);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          results = result;
          temp = result['list'][0]['main']['temp'];
          weatherIcon = result['list'][0]['weather'][0]['main'];
          weather = result['list'][0]['weather'][0]['main'];
          windSpeed = result['list'][0]['wind']['speed'];
          pressureVlaue = result['list'][0]['main']['pressure'];
          humidityLevel = result['list'][0]['main']['humidity'];
        });
      } else {
        debugPrint("Failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black38,
        title: Text(
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          "Weather App",
        ),
        actions: [
          Icon(Icons.search, size: 30, color: const Color.fromARGB(255, 186, 186, 186)),
          Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5)),
        ],
      ),
      drawer: Drawer(
        child: Column(children: [DrawerHeader(child: Text("W E A T H E R"))]),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.only(top: 20, left: 10, right: 10, bottom: 10),
        child: Column(
          children: [
            // main container which show the recent Weather
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 49, 48, 48),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.all(8),
                    child: Column(
                      children: [
                        Text(
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          "$temp k",
                        ),
                        Icon(
                          weatherIcon == "Rain"
                              ? Icons.cloudy_snowing
                              : weatherIcon == "Clear"
                              ? Icons.sunny
                              : Icons.cloud,
                          size: 120,
                        ),
                        SizedBox(height: 6),
                        Text(
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                          weather,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            // this is the forcast part
            SizedBox(
              width: double.infinity,
              child: Text(
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                "Hourly Forcast",
              ),
            ),
            SizedBox(height: 10),
            // scrollable forcast
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                itemBuilder: (context, index) {
                  final hourlyData = results['list'][index + 1];
                  final hourlyTemp = hourlyData['main']['temp'].toString();
                  final hourlyWeatherIcon = hourlyData['weather'][0]['main'];
                  DateTime parsedDate = DateTime.parse(hourlyData['dt_txt']);
                  String formattedTime = DateFormat.jm().format(parsedDate);
                  return Forcastwidget(
                    time: formattedTime,
                    icon: hourlyWeatherIcon,
                    temp: hourlyTemp,
                  );
                },
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: Text(
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                "Additional Information",
              ),
            ),
            SizedBox(
              child: Row(
                children: [
                  Additional(
                    title: "Humidity",
                    icon: "Humidity",
                    value: humidityLevel.toString().toString(),
                  ),
                  Additional(
                    title: "Wind Speed",
                    icon: "Air",
                    value: windSpeed.toString(),
                  ),
                  Additional(
                    title: "Pressure",
                    icon: "Pressure",
                    value: pressureVlaue.toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
