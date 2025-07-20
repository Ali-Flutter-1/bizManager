import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/productItemProvider.dart';
import '../../Widgets/product_screen_widget.dart';

class DashboardScreen extends StatelessWidget {
   DashboardScreen({super.key});


  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().products;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Dashboard',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              fontFamily: 'Font',
              color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/img_1.png',
                      width: 100, height: 100),
                  Text(
                    "No products added yet",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        fontFamily: 'Font'),
                  ),
                ],
              ),
            )
          : buildUI(context),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.white,
              isScrollControlled: true,
              context: context,
              builder: (_) => const AddProductBottomSheet(),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
  Widget buildUI(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        searchBar(context),
        const SizedBox(height: 10),
        productItems(context),
      ],
    );
  }


  Widget searchBar(BuildContext context){

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 50,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12)),
          child: TextField(
            controller: _searchController,
            onChanged: (value){
              context.read<ProductProvider>().searchItem(value);
            },
            decoration: InputDecoration(
              hintText: 'Search for Products..',
              counterStyle: TextStyle(color: Colors.black,fontFamily: 'Font1'),
              filled: true,
              fillColor: Colors.white,

              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colors.black,

              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.black),
                onPressed: () {
                  _searchController.clear();
                  context.read<ProductProvider>().searchItem('');
                },
              ),

              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
      ),
    );
  }

  Widget productItems(BuildContext context){
    final products = context.watch<ProductProvider>().products;
    return  Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (_, index) {
            final product = products[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  width: 172,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                    image: DecorationImage(
                      image: FileImage(File(product.imagePath)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rs: ${product.price}",
                          style: const TextStyle(fontSize: 14, fontFamily: 'Font1', fontWeight: FontWeight.w400)),
                      Text("Qty: ${product.quantity}",
                          style: const TextStyle(fontSize: 14, fontFamily: 'Font1', fontWeight: FontWeight.w400)),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );

  }
}
