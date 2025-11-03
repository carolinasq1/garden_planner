import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/weather.dart';
import '../../domain/use_cases/get_weather_use_case.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherUseCase getWeatherUseCase;

  WeatherBloc({
    required this.getWeatherUseCase,
  }) : super(WeatherInitial()) {
    on<FetchWeatherEvent>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    try {
      final weather = await getWeatherUseCase.call();
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}

