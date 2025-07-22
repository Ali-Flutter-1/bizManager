import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../CustomWidgets/customToast.dart';
import '../Model/product_item.dart';

class ProductProvider with ChangeNotifier {
  final Box<Product> _productBox = Hive.box<Product>('productsBox');

  List<Product> _filteredProducts = [];

  List<Product> get products {
    if (_filteredProducts.isNotEmpty) {
      return _filteredProducts;
    } else {
      return _productBox.values.toList();
    }
  }

  void addProduct(Product product) {
    _productBox.add(product);
    notifyListeners();
  }

  void searchItem(String query) {
    if (query.isEmpty) {
      _filteredProducts = [];
    } else {
      _filteredProducts = _productBox.values
          .where((product) =>
          product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }


  void deleteProduct(Product product) {
    product.delete();
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    product.quantity += 1;
    product.save();
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    if (product.quantity > 1) {
      product.quantity -= 1;
      product.save(); // update Hive
      notifyListeners();
    }
  }

  void updateProductAfterTransaction(Product product, int quantity,
      double amount, String type, BuildContext context) {
    final key = product.key;

    final existingProduct = _productBox.get(key);
    if (existingProduct != null) {
      final oldQuantity = existingProduct.quantity;
      final oldPrice = existingProduct.price;

      if (type == 'Buy') {
        final newTotalQuantity = oldQuantity + quantity;
        final newPrice = amount / quantity;

        // Calculate weighted average and round to 2 decimals
        final updatedPrice = ((oldQuantity * oldPrice) +
            (quantity * newPrice)) / newTotalQuantity;
        final roundedPrice = double.parse(updatedPrice.toStringAsFixed(2));

        existingProduct.quantity = newTotalQuantity;
        existingProduct.price = roundedPrice;
      } else if (type == 'Sell') {
        if (oldQuantity >= quantity) {
          existingProduct.quantity = oldQuantity - quantity;
          // Do not change price on Sell
        } else {
          showCustomToast(context,
              'Not enough stock to sell. Available: $oldQuantity, Requested: $quantity',
              isError: true);
          return;
        }
      }

      existingProduct.save();
      notifyListeners();
    } else {
      debugPrint(" Product not found in Hive box.");
    }
  }
}