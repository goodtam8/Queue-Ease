import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fyp_mobile/login.dart';
import 'package:fyp_mobile/property/customer_count.dart';
import 'package:fyp_mobile/property/payment_data.dart';
import 'package:fyp_mobile/property/restaurant.dart';
import 'package:fyp_mobile/property/singleton/RestuarantService.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  late Future<List<Map<String, dynamic>>> _paymentDataFuture;
  final ScreenshotController screenshotController = ScreenshotController();
  final Restuarantservice service = Restuarantservice();
  Future<List<DailyCustomerCount>> fetchDailyCustomerCounts() async {
    final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/record/daily-customer-counts"),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => DailyCustomerCount.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load daily customer counts');
    }
  }

  Widget buildBarChart(List<DailyCustomerCount> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 350,
        height: 250,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: data.isEmpty
                ? 10
                : (data
                        .map((e) => e.count.toDouble())
                        .reduce((a, b) => a > b ? a : b) *
                    1.2),
            barGroups: data.asMap().entries.map((entry) {
              int index = entry.key;
              DailyCustomerCount dataPoint = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: dataPoint.count.toDouble(),
                    color: Colors.blue,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < data.length) {
                      final date = data[index].date;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${date.month}/${date.day}',
                          style: TextStyle(fontSize: 10.0),
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 35, // Provide more space for labels
                  interval: 1, // Force interval between labels to be 1
                  getTitlesWidget: (value, meta) {
                    // Only show labels for integer values
                    if (value == value.roundToDouble()) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: 10.0),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
          ),
        ),
      ),
    );
  }

  Widget dailyCustomerCountChart() {
    return FutureBuilder<List<DailyCustomerCount>>(
      future: fetchDailyCustomerCounts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No customer data available'));
        } else {
          return buildBarChart(snapshot.data!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
            child: Column(
          children: [
            Text(
              "The last 7 days of Transaction Record",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            linechart(),
            SizedBox(
              height: 10.0,
            ),
            resttoken(),
            SizedBox(
              height: 50,
            ),
            const Text(
              "Daily Customer Count",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            dailyCustomerCountChart(),
          ],
        )),
      ),
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

  Widget buildaiandchart(Map<String, Map<String, int>> bookingStats) {
    return FutureBuilder(
        future: getBotAnalytic(bookingStats),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No payment data available'));
          } else {
            return Container();
          }
        });
  }

  Future<List<Map<String, dynamic>>> fetchBookingStats() async {
    final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/table/stats/restaurant"),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load booking stats');
    }
  }

  late Future<String?> _tokenValue;
  @override
  void initState() {
    _tokenValue = storage.read(key: 'jwt');
    super.initState();
  }

  Widget resttoken() {
    return FutureBuilder<String?>(
        future: _tokenValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/update');
                },
                child: const Text("Update"),
              ),
            );
          } else if (snapshot.hasError) {
            print("hi there is the error occur");
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> decodedToken =
                JwtDecoder.decode(snapshot.data as String);
            String oid = decodedToken["_id"].toString();

            return restaurantget(oid);
          }
        });
  }

  Widget restaurantget(String oid) {
    return FutureBuilder<Restaurant>(
        future: service.getrestaurant(oid),
        builder: (BuildContext context, AsyncSnapshot<Restaurant> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return piechart(snapshot.data!.name);
          } else {
            return const Text('Unexpected error occurred');
          }
        });
  }

  Map<String, Map<String, int>> parseBookingStats(
      List<Map<String, dynamic>> data) {
    Map<String, Map<String, int>> stats = {};

    for (var entry in data) {
      String restaurant = entry['_id']['belong'];
      String status = entry['_id']['status'];
      int total = entry['total'];

      if (!stats.containsKey(restaurant)) {
        stats[restaurant] = {'free': 0, 'available': 0};
      }

      stats[restaurant]![status] = total;
    }

    return stats;
  }

  Widget piechart(String name) {
    return FutureBuilder(
      future: fetchBookingStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No booking stats available'));
        } else {
          return buildPieChart(parseBookingStats(snapshot.data!), name);
        }
      },
    );
  }

  Widget buildPieChart(
      Map<String, Map<String, int>> bookingStats, String name) {
    // Filter the map to find the entry with the key equal to the provided name
    var filteredEntry = bookingStats.entries
        .where((entry) => entry.key == name)
        .take(1)
        .toList();

    if (filteredEntry.isEmpty) {
      return Center(child: Text('No data available for $name'));
    }

    var entry = filteredEntry.first;
    String restaurant = entry.key;
    Map<String, int> stats = entry.value;

    return Column(
      children: [
        const Text(
          "name",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(
          height: 10.0,
        ),
        SizedBox(
          height: 200.0,
          width: 200.0,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                    color: Colors.green,
                    value: stats['in used']!.toDouble(),
                    title: 'in used:${stats['in used']}',
                    radius: 100,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    showTitle: true),
                PieChartSectionData(
                    color: Colors.blue,
                    value: stats['available']!.toDouble(),
                    title: 'Available:${stats['available']}',
                    radius: 100,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    showTitle: true),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ],
    );
  }

  Future<String> getBotAnalytic(
      Map<String, Map<String, int>> bookingStats) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/gpt/analysis"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': bookingStats}), // Send the user's message
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final botReply = responseData['reply'];
        // Process the bot's reply as needed
        print('Bot reply: $botReply');
        return botReply;
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return "Error";
      }
    } catch (e) {
      print('Error: $e');
      return "Error";
    }
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
    final latestData = filteredData.take(10).toList();

    print(latestData);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 350,
        height: 200,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: latestData.map((data) {
                  return FlSpot(
                    data['date'].millisecondsSinceEpoch.toDouble(),
                    data['amount'].toDouble(),
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
