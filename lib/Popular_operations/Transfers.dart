import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(255, 58, 55, 199);

class TransferItem extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final bool isIncome;
  final String imagePath;

  const TransferItem({
    Key? key,
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 0.1, color: primaryColor),
              color: Colors.white,
            ),
            child: Center(
              child: Image.asset(imagePath, fit: BoxFit.cover, width: 35, height: 35),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(amount, style: TextStyle(color: isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}


