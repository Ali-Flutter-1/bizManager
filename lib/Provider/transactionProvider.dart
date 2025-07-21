import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../Model/Transaction/transaction.dart';
import 'dart:core';




class TransactionProvider with ChangeNotifier {
  final Box<Transaction> _transactionBox = Hive.box<Transaction>('transactionsBox');

  List<Transaction> get allTransactions => _transactionBox.values.toList();

  List<Transaction> getBuyTransactions() =>
      _transactionBox.values.where((t) => t.type == "Buy").toList();

  List<Transaction> getSellTransactions() =>
      _transactionBox.values.where((t) => t.type == "Sell").toList();

  void addTransaction(Transaction transaction) {
    _transactionBox.add(transaction);
    notifyListeners();
  }

  void deleteTransaction(Transaction transaction) {
    transaction.delete();
    notifyListeners();
  }

  /// Filter by a specific day
  List<Transaction> getTransactionsForDate(DateTime date) {
    return _transactionBox.values.where((t) =>
    t.dateTime.year == date.year &&
        t.dateTime.month == date.month &&
        t.dateTime.day == date.day).toList();
  }

  /// Filter by week
  List<Transaction> getTransactionsForWeek(DateTime startOfWeek) {
    return _transactionBox.values.where((t) {
      final diff = t.dateTime.difference(startOfWeek).inDays;
      return diff >= 0 && diff < 7;
    }).toList();
  }

  /// Filter by month
  List<Transaction> getTransactionsForMonth(DateTime date) {
    return _transactionBox.values.where((t) =>
    t.dateTime.year == date.year &&
        t.dateTime.month == date.month).toList();
  }

  /// Filter by year
  List<Transaction> getTransactionsForYear(int year) {
    return _transactionBox.values.where((t) => t.dateTime.year == year).toList();
  }

  double calculateTotalAmount(List<Transaction> transactions) {
    return transactions.fold(0.0, (sum, t) => sum + t.amount);
  }
}
