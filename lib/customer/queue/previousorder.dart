import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/order.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:http/http.dart' as http;

class Previousorder extends StatefulWidget {
  const Previousorder({Key? key}) : super(key: key);

  @override
  State<Previousorder> createState() => _PreviousorderState();
}

class _PreviousorderState extends State<Previousorder> {
// Fetch orders for a given receipt/rid
  Future<List<Order>> fetchOrders(String rid) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/receipt/$rid/all'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    return listFromJson(data['result']);
  }

// A helper to re-trigger the FutureBuilder on pull-to-refresh
  Future<void> _refreshOrders(String rid) async {
    setState(() {});
  }

// Build a card for each order
  Widget buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
// Optionally do something when the order is tapped
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
// Display the order ID or a title if available
              Text(
                "Order ID: ${order.rid}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
// Display all order details using the spread operator.
              ...order.orderDetail.map(
                (detail) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    detail.title,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Build the orders list using FutureBuilder and display appropriate
// states for loading, error, or no data.
  Widget buildOrdersList(String rid) {
    return FutureBuilder<List<Order>>(
      future: fetchOrders(rid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${snapshot.error}"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No previous orders found."));
        } else {
          final orders = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () => _refreshOrders(rid),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return buildOrderCard(orders[index]);
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
// Ensure that the rid is provided. Adjust if you also need the restaurant info.
    final String rid = args?['rid'] ?? '';

    return Scaffold(
      appBar: Topbar(),
      body: rid.isNotEmpty
          ? buildOrdersList(rid)
          : const Center(child: Text("Invalid order information.")),
      backgroundColor: Colors.white,
    );
  }
}
