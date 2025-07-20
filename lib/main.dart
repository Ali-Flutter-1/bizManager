import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:management/View/Screens/Dashboard/dashboard_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';


import 'Model/product_item.dart';
import 'Provider/productItemProvider.dart';
import 'View/Widgets/product_screen_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();

  Hive.init(dir.path);
  Hive.registerAdapter(ProductAdapter());
  await Hive.openBox<Product>('productsBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false,
        home: DashboardScreen(), // or DashboardScreen()
      ),
    ),
  );
}
