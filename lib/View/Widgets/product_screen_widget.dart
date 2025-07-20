import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:management/CustomWidgets/customToast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../CustomWidgets/customButton.dart';
import '../../CustomWidgets/customTextfield.dart';
import '../../Model/product_item.dart';
import '../../Provider/productItemProvider.dart';
import 'package:path/path.dart' as path;


class AddProductBottomSheet extends StatefulWidget {
  const AddProductBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddProductBottomSheet> createState() => _AddProductBottomSheetState();
}

class _AddProductBottomSheetState extends State<AddProductBottomSheet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add Product", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Name",style: TextStyle(
              fontFamily: 'Font1',fontSize: 18,fontWeight: FontWeight.w500
            ),),
            CustomTextField(controller: nameController, hintText: 'Enter Product Name',width: MediaQuery.of(context).size.width,),
            Text("Price",style: TextStyle(
                fontFamily: 'Font1',fontSize: 18,fontWeight: FontWeight.w500
            ),),
            CustomTextField(controller: priceController, hintText: 'Enter Price', keyboardType: TextInputType.number,width: MediaQuery.of(context).size.width),
            Text("Quantity",style: TextStyle(
                fontFamily: 'Font1',fontSize: 18,fontWeight: FontWeight.w500
            ),),
            CustomTextField(controller: quantityController, hintText: 'Enter Quantity', keyboardType: TextInputType.number,width: MediaQuery.of(context).size.width),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    width: 150,
                    text: "Camera",
                    backgroundColor: Color(0xFFCCCCCC),
                    textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    width: 150,
                    text: "Gallery",
                    backgroundColor: Color(0xFFCCCCCC),
                    textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              width: double.infinity,
              text: "Add Product",
              backgroundColor: Colors.black,
              textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
              onPressed: () { _saveProduct(context);
            }
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      final appDir = await getApplicationDocumentsDirectory();

      final fileName = path.basename(pickedFile.path);


      final savedImage = File('${appDir.path}/$fileName');


      await savedImage.parent.create(recursive: true);


      await file.copy(savedImage.path);

      setState(() {
        _image = savedImage;
      });
    }
  }


  void _saveProduct(BuildContext context) {
    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.trim()) ?? 0;
    final quantity = int.tryParse(quantityController.text.trim()) ?? 0;

    if (name.isNotEmpty && _image != null) {
      final product = Product(
        name: name,
        price: price,
        quantity: quantity,
        imagePath: _image!.path,
      );

      Provider.of<ProductProvider>(context, listen: false).addProduct(product);
      Navigator.pop(context); // Close the bottom sheet
    } else {
     showCustomToast(context, 'Please fill all fields and select an image',isError: true
      );
    }
  }
}
