import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Provider/transactionProvider.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.allTransactions;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(onTap: (){
          // context.goNamed('dashboard');
        },
            child: Icon(Icons.arrow_back_outlined,size: 30,color: Colors.white,)),
        backgroundColor: Colors.black,
        title: Text('Transactions History' ,style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            fontFamily: 'Font',
            color: Colors.white),),
        centerTitle: true,
      ),
      body: transactions.isEmpty
          ? const Center(child: Text("No transactions yet.",style: TextStyle(
      fontWeight: FontWeight.w600,
          fontSize: 24,
          fontFamily: 'Font',
          color: Colors.black),))
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(
                tx.type == "Buy" ? Icons.shopping_cart : Icons.sell,
                color: tx.type == "Buy" ? Colors.green : Colors.red,
              ),
              title: Text('${tx.type} - ${tx.productName}'),
              subtitle: Text(
                'Quantity: ${tx.quantity}\n'
                    'Amount: Rs ${tx.amount.toStringAsFixed(2)}\n'
                    'By: ${tx.partyName}',
              ),
              trailing: Text(
                '${tx.dateTime.day}/${tx.dateTime.month}/${tx.dateTime.year}',
                style: const TextStyle(fontSize: 12),
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
