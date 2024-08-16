import 'dart:convert';

class WeatherForecast {
  final String generalSituation;
  final List<Forecast> weatherForecast;
  final String updateTime;
  final SeaTemperature seaTemp;
  final List<SoilTemperature> soilTemp;

  WeatherForecast({
    required this.generalSituation,
    required this.weatherForecast,
    required this.updateTime,
    required this.seaTemp,
    required this.soilTemp,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    var forecastList = json['weatherForecast'] as List;
    List<Forecast> forecasts = forecastList.map((e) => Forecast.fromJson(e)).toList();

    var soilTempList = json['soilTemp'] as List;
    List<SoilTemperature> soilTemps = soilTempList.map((e) => SoilTemperature.fromJson(e)).toList();

    return WeatherForecast(
      generalSituation: json['generalSituation'],
      weatherForecast: forecasts,
      updateTime: json['updateTime'],
      seaTemp: SeaTemperature.fromJson(json['seaTemp']),
      soilTemp: soilTemps,
    );
  }
}

class Forecast {
  final String forecastDate;
  final String week;
  final String forecastWind;
  final String forecastWeather;
  final Map<String, dynamic> forecastMaxtemp;
  final Map<String, dynamic> forecastMintemp;
  final Map<String, dynamic> forecastMaxrh;
  final Map<String, dynamic> forecastMinrh;
  final int forecastIcon;
  final String psr;

  Forecast({
    required this.forecastDate,
    required this.week,
    required this.forecastWind,
    required this.forecastWeather,
    required this.forecastMaxtemp,
    required this.forecastMintemp,
    required this.forecastMaxrh,
    required this.forecastMinrh,
    required this.forecastIcon,
    required this.psr,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      forecastDate: json['forecastDate'],
      week: json['week'],
      forecastWind: json['forecastWind'],
      forecastWeather: json['forecastWeather'],
      forecastMaxtemp: json['forecastMaxtemp'],
      forecastMintemp: json['forecastMintemp'],
      forecastMaxrh: json['forecastMaxrh'],
      forecastMinrh: json['forecastMinrh'],
      forecastIcon: json['ForecastIcon'],
      psr: json['PSR'],
    );
  }
}

class SeaTemperature {
  final String place;
  final int value;
  final String unit;
  final String recordTime;

  SeaTemperature({
    required this.place,
    required this.value,
    required this.unit,
    required this.recordTime,
  });

  factory SeaTemperature.fromJson(Map<String, dynamic> json) {
    return SeaTemperature(
      place: json['place'],
      value: json['value'],
      unit: json['unit'],
      recordTime: json['recordTime'],
    );
  }
}

class SoilTemperature {
  final String place;
  final double value;
  final String unit;
  final String recordTime;
  final Map<String, dynamic> depth;

  SoilTemperature({
    required this.place,
    required this.value,
    required this.unit,
    required this.recordTime,
    required this.depth,
  });

  factory SoilTemperature.fromJson(Map<String, dynamic> json) {
    return SoilTemperature(
      place: json['place'],
      value: json['value'],
      unit: json['unit'],
      recordTime: json['recordTime'],
      depth: json['depth'],
    );
  }
}

WeatherForecast parseWeatherForecast(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return WeatherForecast.fromJson(parsed);
}
