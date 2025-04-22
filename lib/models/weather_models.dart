class Weather {
  final String cityName;
  final double temprature;
  final String maincondition;
  final double feelslike;
  final double humidity;
  final double wind;
  final int sunrise;
  final int sunset;

  Weather({
    required this.cityName,
    required this.temprature,
    required this.maincondition,
    required this.feelslike,
    required this.humidity,
    required this.wind,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temprature: json['main']['temp'].toDouble(),
      maincondition: json['weather'][0]['main'],
      feelslike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      wind: json['wind']['speed'].toDouble(),
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
}
