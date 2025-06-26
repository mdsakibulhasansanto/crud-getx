
import 'package:flutter/material.dart';

class ProductUpdateScreen extends StatefulWidget {
  const ProductUpdateScreen({super.key});

  static String name = '/ProductUpdateScreen';

  @override
  State<ProductUpdateScreen> createState() => _ProductUpdateScreenState();
}

class _ProductUpdateScreenState extends State<ProductUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Product update screen "),
      ),
    );
  }
}
