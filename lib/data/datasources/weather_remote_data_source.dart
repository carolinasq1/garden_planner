import '../../domain/entities/weather.dart';

abstract class WeatherRemoteDataSource {
  Future<Weather> getCurrentWeather();
}

