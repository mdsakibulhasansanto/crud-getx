
import 'package:crud/ui/widgets/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/product_update_controller.dart';
import 'home_screen.dart';

class ProductUpdateScreen extends StatefulWidget {
  const ProductUpdateScreen({super.key});
  static String name = "/ProductUpdateScreen";

  @override
  State<ProductUpdateScreen> createState() => _ProductUpdateScreenState();
}

class _ProductUpdateScreenState extends State<ProductUpdateScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _unitPrice = TextEditingController();
  final TextEditingController _totalPrice = TextEditingController();
  final TextEditingController _qty = TextEditingController();
  final TextEditingController _imageUrl = TextEditingController();
  final TextEditingController _code = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ProductUpdateController _productUpdateController = Get.put(ProductUpdateController());

  bool _dataAddInProgress = false;

  late Map<String, dynamic> productData;
  late String id;

  @override
  void initState() {
    super.initState();


    productData = Get.arguments;
    id = productData['id'];


    _name.text = productData['name'] ?? '';
    _unitPrice.text = productData['price']?.toString() ?? '';
    _totalPrice.text = productData['totalPrice']?.toString() ?? '';
    _qty.text = productData['qu']?.toString() ?? '';
    _imageUrl.text = productData['imageUrl'] ?? '';
    _code.text = productData['code'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Product Update'),
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
                buildTextField(_code, 'Code', 'Code required'),
                const SizedBox(height: 70),
                Visibility(
                  visible: !_dataAddInProgress,
                  replacement: const Center(child: CircularProgressIndicator(color: Colors.green)),
                  child: ElevatedButton(
                    onPressed: () {
                      _productUpdate(id);

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                    ),
                    child: const Text('Update Product', style: TextStyle(color: Colors.black54)),
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

  Future<void> _productUpdate(String id) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _dataAddInProgress = true);

      Map<String, dynamic> updatedData = {
        'ProductName': _name.text.trim(),
        'UnitPrice': _unitPrice.text.trim(),
        'TotalPrice': _totalPrice.text.trim(),
        'Qty': _qty.text.trim(),
        'Img': _imageUrl.text.trim(),
        'ProductCode': _code.text.trim(),
      };

      bool isSuccess = await _productUpdateController.updateProduct(id, updatedData);

      if (isSuccess) {
        showSnackBar(context, 'Product updated successfully');
        Get.offAllNamed(HomeScreen.name);
        _clearForm();
      } else {
        showSnackBar(context, 'Failed to update product.');
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
