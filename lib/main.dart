import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:management/AuthScreen/login_screen.dart';
import 'package:management/AuthScreen/signUp_screen.dart';
import 'package:management/View/Screens/Dashboard/dashboard_screen.dart';
import 'package:management/splash/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'Model/Transaction/transaction.dart';
import 'Model/product_item.dart';
import 'Provider/productItemProvider.dart';
import 'View/Screens/Dashboard/Transaction/transaction_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(TransactionAdapter());


  await Hive.openBox<Product>('productsBox');
  await Hive.openBox('authBox');
  await Hive.openBox<Transaction>('transactionsBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp.router(debugShowCheckedModeBanner: false, routerConfig: _router,),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: "/splash",
  routes: <RouteBase>[
    GoRoute(
      name: 'splash',
      path: "/splash",
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: 'login',
      path: "/login",
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      name: 'signup',
      path: "/signup",
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      name: 'dashboard',
      path: "/dashboard",
      builder: (context, state) => DashboardScreen(),
    ),
    GoRoute(
      path: '/add-transaction/:productName',
      name: 'addTransaction',
      builder: (context, state) {
        final productName = state.pathParameters['productName']!;
        final imagePath = state.extra as String;
        return TransactionEntryScreen(
          productName: productName,
          productImagePath: imagePath,
        );
      },
    ),
  ],
);
