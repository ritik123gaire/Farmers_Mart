// ignore_for_file: use_key_in_widget_constructors

import 'package:farmers_mart/screens/bill_receipt_page.dart';
import 'package:farmers_mart/screens/payment_successful_page.dart';
import 'package:flutter/material.dart';
import 'screens/loading_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/profile_page.dart';
import 'screens/products_page.dart';
// import 'screens/cart_page.dart';

void main() {
  runApp(FarmersMartApp());
}

class FarmersMartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmer\'s Mart',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 14),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/profile': (context) => const ProfilePage(),
        '/products': (context) => const ProductsPage(),
        '/paymentSuccess': (context) =>
            const PaymentSuccessfulPage(amount: 0.0),
        '/billing': (context) => const BillReceiptPage(
              products: [],
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
