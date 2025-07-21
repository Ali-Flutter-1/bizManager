import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  final String productName;

  @HiveField(1)
  final String imagePath;

  @HiveField(2)
  final String partyName; // Buyer or Seller

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final double amount;

  @HiveField(5)
  final DateTime dateTime;

  @HiveField(6)
  final String type; // 'Buy' or 'Sell'

  Transaction({
    required this.productName,
    required this.imagePath,
    required this.partyName,
    required this.quantity,
    required this.amount,
    required this.dateTime,
    required this.type,
  });
}
