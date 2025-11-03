import '../../domain/entities/weather.dart';

class WeatherModel {
  final double temperature;
  final int weathercode;

  WeatherModel({
    required this.temperature,
    required this.weathercode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final currentWeather = json['current_weather'] as Map<String, dynamic>;
    return WeatherModel(
      temperature: (currentWeather['temperature'] as num).toDouble(),
      weathercode: currentWeather['weathercode'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_weather': {
        'temperature': temperature,
        'weathercode': weathercode,
      },
    };
  }

  Weather toEntity() {
    return Weather(
      temperature: temperature,
      weathercode: weathercode,
    );
  }

  factory WeatherModel.fromEntity(Weather weather) {
    return WeatherModel(
      temperature: weather.temperature,
      weathercode: weather.weathercode,
    );
  }
}

