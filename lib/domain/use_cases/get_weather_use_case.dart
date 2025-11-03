import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetWeatherUseCase {
  final WeatherRepository repository;

  GetWeatherUseCase(this.repository);

  Future<Weather> call() async {
    return await repository.getCurrentWeather();
  }
}
