import 'dart:convert';

class Menu {
  final String id;
  final String name;
  final int price;
  final String image;

  const Menu({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: json['price'] as int? ?? 0,
      image: json['image'] as String? ?? '',
    );
  }

  static List<Menu> listFromJson(List<dynamic> json) {
    return json.map((item) => Menu.fromJson(item)).toList();
  }
}
