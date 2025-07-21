import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

}
