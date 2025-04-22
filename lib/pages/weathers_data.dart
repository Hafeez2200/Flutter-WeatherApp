
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/models/animation_models.dart';
import 'package:weatherapp/models/weather_models.dart';
import 'package:weatherapp/services/weather_services.dart';

class WeatherData extends StatefulWidget {
   const WeatherData({required this.cityName,super.key});
   final String cityName;
  

  @override
  State<WeatherData> createState() => _WeatherDataState();
}



class _WeatherDataState extends State<WeatherData> {

  

  final _weatherServices = WeatherServices("Your API Key");
  Weather? _weather;
  String? _cityName;

  
 _fetchWeather() async {
    
    try {
      if (widget.cityName.isNotEmpty) {
        final weather = await _weatherServices.getWeatherByCity(widget.cityName);
        setState(() {
          _weather = weather;
          _cityName = widget.cityName;
        });
      } else {
         Position position = await _determinePosition();
        
        String city = await _getCityName(position.latitude, position.longitude);
        
        final weather = await _weatherServices.getWeatherByCity(city);
        setState(() {
          _weather = weather;
          _cityName = city; // Set the detected city name
        });
        
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied.");
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> _getCityName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        
        return placemarks[0].locality ?? "Unknown City";
        
      }
    } catch (e) {
      print("Error getting city name: $e");
    }
    return "Unknown City";
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }


  String formatTime(int timeStamp){
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp*1000);
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
  AnimationModels animationModels= new AnimationModels();

  @override
  Widget build(BuildContext context) {
    return _weather != null
                  ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              //"CityName",
                              _cityName!,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Lottie.asset(animationModels.getweatheranimation(_weather?.maincondition), width: 300),
                      
                            Text(
                              //"Temprature",
                              "${_weather!.temprature.toStringAsFixed(0)}°C",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              //"Condition",
                              _weather!.maincondition,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 20),
                            //Divider(),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Icons.thermostat,
                                      color: Colors.deepOrange,
                                      size: 30,
                                    ),
                                    Text(
                                      "Feels Like",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "${_weather!.feelslike.toStringAsFixed(0)}°C",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    /*Text(
                                  "20C",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),*/
                                  ],
                                ),
                      
                                Column(
                                  children: [
                                    Icon(
                                      Icons.opacity,
                                      color: Colors.lightBlue,
                                      size: 30,
                                    ),
                                    Text(
                                      "Humidity",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "${_weather!.humidity.toString()}%",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    /*Text(
                                  "20C",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),*/
                                  ],
                                ),
                      
                                Column(
                                  children: [
                                    Icon(
                                      Icons.air,
                                      color: Colors.cyanAccent,
                                      size: 30,
                                    ),
                                    Text(
                                      "Wind",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "${_weather!.wind.toString()} m/s",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                    /*Text(
                                  "20C",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),*/
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50,),
                      
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.sunny,size: 30,color: Colors.amber,),
                              SizedBox(height: 5,),
                              Text("Sunrise",
                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300, color: Colors.white),),
                              SizedBox(height: 5,),
                              Text(formatTime(_weather!.sunrise),style: TextStyle(fontSize: 16,color: Colors.white),)
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.nightlight_round,size: 30,color: const Color.fromARGB(255, 134, 145, 211),),
                              SizedBox(height: 5,),
                              Text("Sunset",
                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300, color: Colors.white),),
                              SizedBox(height: 5,),
                              Text(formatTime(_weather!.sunset),style: TextStyle(fontSize: 16,color: Colors.white),)
                            ],
                          )
                        ],
                      )
                    ],
                  )
                  : CircularProgressIndicator(color: Colors.white,); 
                  //Text("Enter a city to get weather details");
  }

  @override
  void didUpdateWidget(covariant WeatherData oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If city name changes, fetch new weather data
    if (oldWidget.cityName != widget.cityName) {
      _fetchWeather();
    }
  }
}