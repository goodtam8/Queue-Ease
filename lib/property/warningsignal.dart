import 'dart:convert';

class WeatherWarningSummary {
  final Map<String, WeatherWarning>? warnings;

  WeatherWarningSummary({this.warnings});

  factory WeatherWarningSummary.fromJson(Map<String, dynamic> json) {
    Map<String, WeatherWarning> warningsMap = {};

    json.forEach((key, value) {
      warningsMap[key] = WeatherWarning.fromJson(value);
    });

    return WeatherWarningSummary(warnings: warningsMap.isNotEmpty ? warningsMap : null);
  }
}

class WeatherWarning {
  final String name;
  final String code;
  final String actionCode;
  final String issueTime;
  final String? expireTime;
  final String updateTime;
  final String? type;

  WeatherWarning({
    required this.name,
    required this.code,
    required this.actionCode,
    required this.issueTime,
    this.expireTime,
    required this.updateTime,
    this.type,
  });

  factory WeatherWarning.fromJson(Map<String, dynamic> json) {
    return WeatherWarning(
      name: json['name'],
      code: json['code'],
      actionCode: json['actionCode'],
      issueTime: json['issueTime'],
      expireTime: json['expireTime'],
      updateTime: json['updateTime'],
      type: json['type'],
    );
  }
}

WeatherWarningSummary parseWeatherWarningSummary(String responseBody) {
  final Map<String, dynamic> parsed = jsonDecode(responseBody);
  return WeatherWarningSummary.fromJson(parsed);
}
