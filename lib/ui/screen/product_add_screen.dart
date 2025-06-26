

import 'package:crud/ui/controller/create_product_controller.dart';
import 'package:crud/ui/widgets/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class ProductAddScreen extends StatefulWidget {
  const ProductAddScreen({super.key});
  static String name = "/ProductAddScreen";

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _unitPrice = TextEditingController();
  final TextEditingController _totalPrice = TextEditingController();
  final TextEditingController _qty = TextEditingController();
  final TextEditingController _imageUrl = TextEditingController();
  final TextEditingController _code = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CreateProductController _productController = Get.put(CreateProductController());

  bool _dataAddInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildTextField(_name, 'Name', 'Name required'),
                const SizedBox(height: 15),
                buildTextField(_unitPrice, 'Price', 'Enter product price', TextInputType.number),
                const SizedBox(height: 15),
                buildTextField(_totalPrice, 'Total Price', 'Enter total price', TextInputType.number),
                const SizedBox(height: 15),
                buildTextField(_qty, 'Quantity', 'Quantity required', TextInputType.number),
                const SizedBox(height: 15),
                buildTextField(_imageUrl, 'Image URL', 'Image URL required'),
                const SizedBox(height: 15),
                buildTextField(_code, 'Code', 'Code'),
                const SizedBox(height: 70),
                Visibility(
                  visible: !_dataAddInProgress,
                  replacement: const Center(child: CircularProgressIndicator(color: Colors.green)),
                  child: ElevatedButton(
                    onPressed: _productCreate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                    ),
                    child: const Text('Add Product', style: TextStyle(color: Colors.black54)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextField(
      TextEditingController controller,
      String label,
      String errorText, [
        TextInputType? keyboardType,
      ]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black26, fontWeight: FontWeight.bold),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return errorText;
        }
        return null;
      },
    );
  }

  Future<void> _productCreate() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _dataAddInProgress = true);

      Map<String, dynamic> data = {
        'Img': _imageUrl.text.trim(),
        'ProductCode': _code.text.trim(),
        'ProductName': _name.text.trim(),
        'Qty': _qty.text.trim(),
        'TotalPrice': _totalPrice.text.trim(),
        'UnitPrice': _totalPrice.text.trim(),
      };

      bool isSuccess = await _productController.productCreate(data);
      if (isSuccess) {
        showSnackBar(context, 'Product added successfully');
        _clearForm();
        Get.offAllNamed(HomeScreen.name);
      } else {
        showSnackBar(context, ' Failed to add product.');
      }

      setState(() => _dataAddInProgress = false);
    }
  }

  void _clearForm() {
    _name.clear();
    _unitPrice.clear();
    _totalPrice.clear();
    _qty.clear();
    _imageUrl.clear();
    _code.clear();
  }
}
