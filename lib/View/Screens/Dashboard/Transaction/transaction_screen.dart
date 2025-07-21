import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:management/CustomWidgets/customToast.dart';

import 'package:provider/provider.dart';

import '../../../../CustomWidgets/customButton.dart';
import '../../../../CustomWidgets/customTextfield.dart';
import '../../../../Model/Transaction/transaction.dart';
import '../../../../Provider/transactionProvider.dart';


class TransactionEntryScreen extends StatefulWidget {
  final String productName;
  final String productImagePath;

  const TransactionEntryScreen({
    super.key,
    required this.productName,
    required this.productImagePath,
  });

  @override
  State<TransactionEntryScreen> createState() => _TransactionEntryScreenState();
}

class _TransactionEntryScreenState extends State<TransactionEntryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _transactionType = 'Buy';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(onTap: (){
          context.goNamed('dashboard');
        },
            child: Icon(Icons.arrow_back_outlined,size: 30,color: Colors.white,)),
        backgroundColor: Colors.black,
        title: Text('${widget.productName} Transaction' ,style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            fontFamily: 'Font',
            color: Colors.white),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.file(
                File(widget.productImagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/img_2.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),


            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [

                  CustomTextField(
                    hintText: 'Buyyer/Seller Name',
                    width: size.width,
                    height: 70,
                    controller: _nameController,
                    keyboardType: TextInputType.text,

                  ),
                  const SizedBox(height: 12),


                  CustomTextField(
                    hintText: 'Quantity',
                    width: size.width,
                    height: 70,
                    controller: _quantityController,
                    keyboardType: TextInputType.number,

                  ),
                  const SizedBox(height: 12),

                  /// Amount
                  CustomTextField(
                    hintText: 'Amount',
                    width: size.width,
                    height: 70,
                    controller: _amountController,
                    keyboardType: TextInputType.number,

                  ),
                  const SizedBox(height: 12),

                  /// Type Selector
                  DropdownButtonFormField<String>(

                    value: _transactionType,
                    items: const [
                      DropdownMenuItem(value: 'Buy', child: Text('Buy')),
                      DropdownMenuItem(value: 'Sell', child: Text('Sell')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _transactionType = value!;
                      });
                    },dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: 'Transaction Type',
                      border: OutlineInputBorder(),

                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Submit Button
                  CustomButton(
                    text: "Save Transaction",
                    backgroundColor:  Colors.black,
                    width: size.width,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: 'Font',
                      color: Colors.white,
                    ),
                    onPressed: () {

                      final name = _nameController.text.trim();
                      final quantity = int.tryParse(_quantityController.text) ?? 0;
                      final amount = double.tryParse(_amountController.text) ?? 0.0;

                      if (name.isEmpty || quantity == 0 || amount == 0.0) {
                        showCustomToast(context, 'Please fill all fields properly',isError: true);
                        return;
                      }

                      final transaction = Transaction(
                        productName: widget.productName,
                        imagePath: widget.productImagePath,
                        partyName: name,
                        quantity: quantity,
                        amount: amount,
                        type: _transactionType,
                        dateTime: DateTime.now(),
                      );

                      Provider.of<TransactionProvider>(context, listen: false)
                          .addTransaction(transaction);

                      context.goNamed('dashboard');
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

