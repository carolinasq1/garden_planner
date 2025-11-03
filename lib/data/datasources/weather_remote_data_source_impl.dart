import 'package:dio/dio.dart';
import '../../domain/entities/weather.dart';
import '../models/weather_model.dart';
import 'weather_remote_data_source.dart';

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSourceImpl({required this.dio});

  @override
  Future<Weather> getCurrentWeather() async {
    try {
      final response = await dio.get(
        'https://api.open-meteo.com/v1/forecast?latitude=21.88&longitude=-102.29&current_weather=true',
      );

      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        return WeatherModel.fromJson(json).toEntity();
      } else {
        throw Exception('Failed to fetch weather data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message ?? 'Unknown error'}');
    }
  }
}

