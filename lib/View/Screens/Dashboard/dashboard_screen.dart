import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:go_router/go_router.dart';
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
        const SizedBox(height: 20,)
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
   Widget productItems(BuildContext context) {
     final products = context.watch<ProductProvider>().products;
     final provider = context.read<ProductProvider>();

     return Expanded(
       child: ListView.separated(
         padding: const EdgeInsets.symmetric(horizontal: 16),
         itemCount: products.length,
         separatorBuilder: (_, __) => const SizedBox(height: 12),
         itemBuilder: (_, index) {
           final product = products[index];

           return Container(
             height: 140,
             decoration: BoxDecoration(
               color: Colors.grey[100],
               borderRadius: BorderRadius.circular(10),
               border: Border.all(color: Colors.black12),
             ),
             child: Row(
               children: [
                 // Image - no padding, fixed size
                 GestureDetector(
                   onTap: (){
                     context.goNamed(
                       'addTransaction',
                       pathParameters: {
                         'productName': product.name,
                       },
                       extra: product.imagePath,
                     );

                   },
                   child: ClipRRect(
                     borderRadius: const BorderRadius.only(
                       topLeft: Radius.circular(10),
                       bottomLeft: Radius.circular(10),
                     ),
                     child: Image.file(
                       File(product.imagePath),
                       width: 130,
                       height: 140,
                       fit: BoxFit.cover,
                       errorBuilder: (_, __, ___) {
                         return Image.asset(
                           'assets/images/img_2.png',
                           width: 130,
                           height: 140,
                           fit: BoxFit.cover,
                         );
                       },
                     ),
                   ),
                 ),

                 // Details section
                 Expanded(
                   child: Padding(
                     padding: const EdgeInsets.all(10),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         // Name + Delete Icon
                         Row(
                           children: [
                             Expanded(
                               child: Text(
                                 product.name,
                                 style: const TextStyle(
                                   fontSize: 16,
                                   fontWeight: FontWeight.w600,
                                   fontFamily: 'Font',
                                 ),
                                 overflow: TextOverflow.ellipsis,
                               ),
                             ),
                             IconButton(
                               icon: const Icon(Icons.delete, color: Colors.red),
                               onPressed: () {
                                 showDialog(
                                   context: context,
                                   builder: (_) => AlertDialog(
                                     backgroundColor: Colors.black,
                                     title: Center(child: const Text("Delete Product",style: TextStyle(
                                       fontWeight: FontWeight.w500,fontFamily: 'Font',fontSize: 16,color: Colors.white
                                     ),)),
                                     content: const Text("Are you sure you want to delete this product?",style: TextStyle(
                                         fontWeight: FontWeight.w400,fontFamily: 'Font1',fontSize: 14,color: Colors.white
                                     ),),
                                     actions: [
                                       TextButton(
                                         onPressed: () => Navigator.of(context).pop(),
                                         child: const Text("Cancel",style: TextStyle(
                                             fontWeight: FontWeight.w400,fontFamily: 'Font1',fontSize: 14,color: Colors.white
                                         ),),
                                       ),
                                       TextButton(
                                         onPressed: () {
                                           provider.deleteProduct(product);
                                           Navigator.of(context).pop();
                                         },
                                         child: const Text("OK",style: TextStyle(
                                             fontWeight: FontWeight.w400,fontFamily: 'Font1',fontSize: 14,color: Colors.white
                                         ),),
                                       ),
                                     ],
                                   ),
                                 );
                               },
                               padding: EdgeInsets.zero,
                               constraints: const BoxConstraints(),
                             ),

                           ],
                         ),

                         const SizedBox(height: 6),

                         // Price + Quantity buttons
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(
                               'Rs: ${product.price}',
                               style: const TextStyle(
                                 fontSize: 14,
                                 fontFamily: 'Font1',
                               ),
                             ),
                             Row(
                               children: [
                                 _buildRoundButton(
                                   icon: Icons.remove,
                                   onTap: () => provider.decreaseQuantity(product),
                                 ),
                                 const SizedBox(width: 6),
                                 Text(
                                   '${product.quantity}',
                                   style: const TextStyle(
                                     fontSize: 14,
                                     fontWeight: FontWeight.w600,
                                   ),
                                 ),
                                 const SizedBox(width: 6),
                                 _buildRoundButton(
                                   icon: Icons.add,
                                   onTap: () => provider.increaseQuantity(product),
                                 ),
                               ],
                             ),
                           ],
                         ),

                         const SizedBox(height: 6),

                         // Total
                         Text(
                           'Total Rs:  ${product.price * product.quantity}',
                           style: const TextStyle(
                             fontSize: 14,
                             fontFamily: 'Font',
                             fontWeight: FontWeight.w500,
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
             ),
           );
         },
       ),
     );
   }
   Widget _buildRoundButton({required IconData icon, required VoidCallback onTap}) {
     return InkWell(
       onTap: onTap,
       child: Container(
         height: 30,
         width: 30,
         decoration: BoxDecoration(
           color: Colors.black,
           borderRadius: BorderRadius.circular(10),
         ),
         child: Icon(icon, color: Colors.white, size: 20),
       ),
     );
   }


}
