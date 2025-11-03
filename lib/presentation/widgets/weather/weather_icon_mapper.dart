import 'package:flutter/material.dart';

IconData getWeatherIcon(int weatherCode) {
  // I'm only handling 3 codes as it was just to test the API calls
  if (weatherCode == 0) {
    return Icons.wb_sunny;
  }
  if (weatherCode >= 61 && weatherCode <= 82) {
    return Icons.umbrella;
  }
  return Icons.cloud;
}

