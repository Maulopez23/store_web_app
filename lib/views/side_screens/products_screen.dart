import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  static const String screenRoute = "ProductsScreen";

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Products'),
    );
  }
}