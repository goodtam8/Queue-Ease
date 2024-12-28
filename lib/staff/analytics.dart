import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fyp_mobile/property/payment_data.dart';
import 'package:fyp_mobile/property/topbar.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  late Future<List<Map<String, dynamic>>> _paymentDataFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topbar(),
      body: Center(
          child: Column(
        children: [
          Text("The last 7 days of Transaction Record"),
          linechart(),
        ],
      )),
      backgroundColor: Colors.white,
    );
  }

  Widget linechart() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchPaymentData().then(parsePaymentData),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No payment data available'));
        } else {
          return buildLineChart(snapshot.data!);
        }
      },
    );
  }

  Widget buildLineChart(List<Map<String, dynamic>> paymentData) {
    // Get the current date and the date 7 days ago
    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(Duration(days: 7));

    List<Map<String, dynamic>> filteredData = paymentData.where((data) {
      DateTime paymentDate;
      if (data['date'] is String) {
        paymentDate = DateTime.parse(data['date']);
      } else if (data['date'] is DateTime) {
        paymentDate = data['date'];
      } else {
        // Handle unexpected type or throw an error
        throw TypeError();
      }
      return paymentDate.isAfter(sevenDaysAgo) && paymentDate.isBefore(now);
    }).toList();

    filteredData.sort((a, b) {
      DateTime dateA =
          a['date'] is String ? DateTime.parse(a['date']) : a['date'];
      DateTime dateB =
          b['date'] is String ? DateTime.parse(b['date']) : b['date'];
      return dateA.compareTo(dateB);
    });

    // Take the latest 5 entries
    final latestData = filteredData.take(5).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 350, // Set your desired width
        height: 200, // Set your desired height
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: latestData.map((data) {
                  return FlSpot(
                    data['date'].millisecondsSinceEpoch.toDouble(),
                    data['amount'].toDouble() / 100,
                  );
                }).toList(),
                isCurved: false,
                color: Colors.blue,
                barWidth: 4,
                belowBarData: BarAreaData(show: false),
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final xaxis = value.toInt() / 100;
                      return Text('${xaxis}', style: TextStyle(fontSize: 6.0));
                    }),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final date =
                        DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    return Text(
                      '${date.month}/${date.day}',
                      style: TextStyle(fontSize: 4.0),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
