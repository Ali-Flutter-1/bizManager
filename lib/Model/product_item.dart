import 'package:hive/hive.dart';

part 'product_item.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double price;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  String imagePath;

  Product({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imagePath,
  });
}
