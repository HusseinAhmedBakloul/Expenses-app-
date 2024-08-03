import 'dart:convert';

class Debt {
  final String title;
  final DateTime date;
  final double amount;
  final String image;

  Debt({
    required this.title,
    required this.date,
    required this.amount,
    required this.image,
  });

  // تحويل Debt إلى JSON
  String toJson() => json.encode({
    'title': title,
    'date': date.toIso8601String(),
    'amount': amount,
    'image': image,
  });

  // تحويل JSON إلى Debt
  factory Debt.fromJson(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Debt(
      title: jsonMap['title'],
      date: DateTime.parse(jsonMap['date']),
      amount: jsonMap['amount'],
      image: jsonMap['image'],
    );
  }
}
