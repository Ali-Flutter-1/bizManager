import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:go_router/go_router.dart';
import 'package:management/CustomWidgets/customToast.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../CustomWidgets/customButton.dart';
import '../../../../CustomWidgets/customTextfield.dart';
import '../../../../Model/Transaction/transaction.dart';
import '../../../../Model/product_item.dart';
import '../../../../Provider/productItemProvider.dart';
import '../../../../Provider/transactionProvider.dart';

class TransactionEntryScreen extends StatefulWidget {
  final Product product;
  final String productName;
  final String productImagePath;

  TransactionEntryScreen({super.key, required this.product})
      : productName = product.name,
        productImagePath = product.imagePath;

  @override
  State<TransactionEntryScreen> createState() => _TransactionEntryScreenState();
}

class _TransactionEntryScreenState extends State<TransactionEntryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _transactionType = 'Buy';
  Transaction? _lastTransaction;

  final GlobalKey _receiptKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            context.goNamed('dashboard');
          },
          child: const Icon(Icons.arrow_back_outlined, size: 30, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        title: Text(
          '${widget.productName} Transaction',
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 24, fontFamily: 'Font', color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              // if (_lastTransaction != null) {
              //   await _exportReceiptAsImage();
              //   showCustomToast(context, 'Image saved to gallery');
              // } else {
              //   showCustomToast(context, 'No transaction to export yet', isError: true);
              // }
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.image, size: 30, color: Colors.white),
            ),
          )
        ],
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
                    hintText: 'Buyer/Seller Name',
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
                  CustomTextField(
                    hintText: 'Amount',
                    width: size.width,
                    height: 70,
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
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
                    },
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: 'Transaction Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Save Transaction",
                    backgroundColor: Colors.black,
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
                        showCustomToast(context, 'Please fill all fields properly', isError: true);
                        return;
                      }

                      final transaction = Transaction(
                        productName: widget.product.name,
                        imagePath: widget.product.imagePath,
                        partyName: name,
                        quantity: quantity,
                        amount: amount,
                        type: _transactionType,
                        dateTime: DateTime.now(),
                      );

                      _lastTransaction = transaction;

                      Provider.of<TransactionProvider>(context, listen: false)
                          .addTransaction(transaction);

                      Provider.of<ProductProvider>(context, listen: false)
                          .updateProductAfterTransaction(
                        widget.product,
                        quantity,
                        amount,
                        _transactionType,
                        context,

                      );
                      showCustomToast(context, 'Transaction Saved');
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_lastTransaction != null)
                    RepaintBoundary(
                      key: _receiptKey,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Transaction Receipt",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text("Type: ${_lastTransaction!.type}"),
                            Text("Product: ${_lastTransaction!.productName}"),
                            Text("Quantity: ${_lastTransaction!.quantity}"),
                            Text("Amount: Rs ${_lastTransaction!.amount.toStringAsFixed(2)}"),
                            Text("Person: ${_lastTransaction!.partyName}"),
                            Text("Date: ${_lastTransaction!.dateTime.toLocal()}"),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Future<void> _exportReceiptAsImage() async {
  //   if (!await requestStoragePermission()) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Permission denied.')),
  //     );
  //     return;
  //   }
  //
  //   // Check if the context is available
  //   if (_receiptKey.currentContext == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Canvas not available. Try again later.')),
  //     );
  //     return;
  //   }
  //
  //   RenderRepaintBoundary boundary =
  //   _receiptKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //
  //   ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //   ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //
  //   if (byteData == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to convert image')),
  //     );
  //     return;
  //   }
  //
  //   Uint8List imageBytes = byteData.buffer.asUint8List();
  //
  //   final tempDir = await getTemporaryDirectory();
  //   final file = File('${tempDir.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.png');
  //   await file.writeAsBytes(imageBytes);
  //
  //   await GallerySaver.saveImage(file.path);
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Image saved: ${file.path}')),
  //   );
  // }
  //
  // Future<bool> requestStoragePermission() async {
  //   if (Platform.isAndroid) {
  //     if (await Permission.manageExternalStorage.isGranted ||
  //         await Permission.storage.isGranted ||
  //         await Permission.photos.isGranted ||
  //         await Permission.mediaLibrary.isGranted) {
  //       return true;
  //     }
  //
  //     Map<Permission, PermissionStatus> statuses = await [
  //       Permission.manageExternalStorage,
  //       Permission.storage,
  //       Permission.photos,
  //       Permission.mediaLibrary,
  //     ].request();
  //
  //     return statuses.values.any((status) => status.isGranted);
  //   }
  //   return true;
  // }


}
