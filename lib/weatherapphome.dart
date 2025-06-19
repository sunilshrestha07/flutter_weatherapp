import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weatherapp/additional.dart';
import 'package:weatherapp/forcastwidget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weatherapp/search.dart';

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
  bool isFetching = false;
  String cityName = "Kathmandu";

  // Function to fetch data
  Future fetchData() async {
    final uri =
        "http://api.openweathermap.org/data/2.5/forecast?q=$cityName,np&APPID=2f5981bada075205d9597abf9b490fce";
    final url = Uri.parse(uri);

    try {
      setState(() {
        isFetching = true;
      });
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
          isFetching = false;
        });
      } else {
        debugPrint("Failed: ${response.statusCode}");
        setState(() {
          isFetching = false;
        });
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text("Error fetching data for $cityName")));
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() {
        isFetching = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // Callback to update cityName and refetch data
  void _refetchData(String newCityName) {
    setState(() {
      cityName = newCityName.isNotEmpty ? newCityName : cityName;
    });
    fetchData();
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
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Search(cityName: cityName, onPressed: _refetchData);
                },
              );
            },
            icon: Icon(Icons.search), // Changed to search icon for clarity
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
        ],
      ),
      drawer: Drawer(
        child: Column(children: [DrawerHeader(child: Text("W E A T H E R"))]),
      ),
      body: isFetching
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              child: Column(
                children: [
                  // Main container showing recent weather
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
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Text(
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                "${(temp - 273.15).toStringAsFixed(1)} °C", // Convert Kelvin to Celsius
                              ),
                              Icon(
                                weatherIcon == "Rain"
                                    ? Icons.cloudy_snowing
                                    : weatherIcon == "Clear"
                                    ? Icons.wb_sunny
                                    : Icons.cloud,
                                size: 120,
                                color: Colors.white,
                              ),
                              SizedBox(height: 6),
                              Text(
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                weather,
                              ),
                              SizedBox(height: 6),
                              Text(
                                style: TextStyle(fontSize: 18, color: Colors.white),
                                cityName,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  // Forecast part
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      "Hourly Forecast",
                    ),
                  ),
                  SizedBox(height: 10),
                  // Scrollable forecast
                  SizedBox(
                    height: 120,
                    child: results == null
                        ? Center(child: Text("No forecast data"))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              final hourlyData = results['list'][index + 1];
                              final hourlyTemp = (hourlyData['main']['temp'] - 273.15)
                                  .toStringAsFixed(1);
                              final hourlyWeatherIcon = hourlyData['weather'][0]['main'];
                              DateTime parsedDate = DateTime.parse(hourlyData['dt_txt']);
                              String formattedTime = DateFormat.jm().format(parsedDate);
                              return Forcastwidget(
                                time: formattedTime,
                                icon: hourlyWeatherIcon,
                                temp: "$hourlyTemp °C",
                              );
                            },
                          ),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      "Additional Information",
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Additional(
                          title: "Humidity",
                          icon: "Humidity",
                          value: "$humidityLevel%",
                        ),
                        Additional(
                          title: "Wind Speed",
                          icon: "Air",
                          value: "$windSpeed m/s",
                        ),
                        Additional(
                          title: "Pressure",
                          icon: "Pressure",
                          value: "$pressureVlaue hPa",
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
