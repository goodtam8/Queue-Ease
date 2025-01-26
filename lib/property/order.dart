import 'dart:convert';

// Class for OrderDetail
class OrderDetail {
  final String title;
  final int price;

  const OrderDetail({
    required this.title,
    required this.price,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      title: json['title'] as String,
      price: int.parse(json['price']), // Assuming price is always a string
    );
  }
}

// Class for individual order
class Order {
  final String id;
  final String restaurantName;
  final String customerId;
  final List<OrderDetail> orderDetail;
  final int amount;
  final String current;
  final String rid;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.restaurantName,
    required this.customerId,
    required this.orderDetail,
    required this.amount,
    required this.current,
    required this.rid,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    // Parse the orderDetail, which is an array of JSON strings
    List<OrderDetail> orderDetails = (json['orderdetail'] as List)
        .map((detail) => OrderDetail.fromJson(jsonDecode(detail)))
        .toList();

    return Order(
      id: json['_id'] as String,
      restaurantName: json['restaurantname'] as String,
      customerId: json['customerid'] as String,
      orderDetail: orderDetails,
      amount: json['amount'] as int,
      current: json['current'] as String,
      rid: json['rid'] as String,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

// Class for the entire response
class OrderResponse {
  final List<Order> result;

  const OrderResponse({
    required this.result,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      result: (json['result'] as List)
          .map((orderJson) => Order.fromJson(orderJson))
          .toList(),
    );
  }
}

// Function to parse the JSON response
OrderResponse parseOrderResponse(String responseBody) {
  final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
  return OrderResponse.fromJson(parsed);
}
