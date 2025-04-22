import 'package:flutter/material.dart';
import 'package:weatherapp/UI/appbar.dart';
import 'package:weatherapp/models/weather_models.dart';
import 'package:weatherapp/pages/weathers_data.dart';
import 'package:weatherapp/services/weather_services.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String cityName = '';

  void updateCityName(String newCityName) {
    setState(() {
      cityName = newCityName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: CustomAppbar(onsearch: updateCityName),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              const Color.fromARGB(255, 36, 87, 119),
              const Color.fromARGB(255, 15, 19, 37),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [SizedBox(height: 20),
            Container(
              //decoration: BoxDecoration(color: Colors.blueGrey),
              child: WeatherData(cityName: cityName))],
          ),
        ),
      ),
    );
  }
}
