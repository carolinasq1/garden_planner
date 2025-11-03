import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../domain/use_cases/get_weather_use_case.dart';
import '../../bloc/weather_bloc.dart';
import 'weather_icon_mapper.dart';

class WeatherIconWidget extends StatelessWidget {
  const WeatherIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final useCase = di.getIt<GetWeatherUseCase>();
        final bloc = WeatherBloc(getWeatherUseCase: useCase);
        bloc.add(FetchWeatherEvent());
        return bloc;
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (_, state) {
            if (state is WeatherLoaded) {
              return Icon(
                getWeatherIcon(state.weather.weathercode),
                size: 24,
              );
            }
            
            if (state is WeatherError) {
              return const Icon(
                Icons.error_outline,
                size: 24,
              );
            }
            
            // Loading or initial state
            return const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          },
        ),
      ),
    );
  }
}

