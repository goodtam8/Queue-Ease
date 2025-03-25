import 'dart:convert'; // For JSON decoding

class PredictionResponse {
  final bool success;
  final double waitingTime;
  final String message;

  PredictionResponse({required this.success, required this.waitingTime, required this.message});

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      success: json['success'],
      waitingTime: json['waitingTime'].toDouble(),
      message: json['message'],
    );
  }
}
