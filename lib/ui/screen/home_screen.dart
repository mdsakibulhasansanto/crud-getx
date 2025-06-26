import 'package:crud/ui/controller/product_get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/snackBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String name = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ProductGetController _productGetController = Get.find<ProductGetController>();

  @override
  void initState() {
    super.initState();
    getProductMethod();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu, color: Colors.white),
        ),
        title: Text(
          "CRUD APPLICATION",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications, color: Colors.white),
            ),
          ),
        ],
      ),
        body: GetBuilder<ProductGetController>(
          builder: (controller) {
            if (controller.inProgress) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.productList.isEmpty) {
              return const Center(child: Text("No products found."));
            }

            return ListView.builder(
              itemCount: controller.productList.length,
              itemBuilder: (context, index) {
                final product = controller.productList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      backgroundImage: product.img != null ? NetworkImage(product.img!) : null,
                      child: product.img == null ? const Icon(Icons.image_not_supported) : null,
                    ),
                    title: Text(product.productName ?? 'No name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Code: ${product.productCode ?? 'N/A'}"),
                        Text("Price: ${product.unitPrice ?? '0'} x ${product.qty ?? '0'} = ${product.totalPrice ?? '0'}"),
                      ],
                    ),
                    trailing: Text(product.createdDate ?? '', style: const TextStyle(fontSize: 12)),
                  ),
                );
              },
            );
          },
        )

    );
  }


  Future<void> getProductMethod () async {

    final bool isSuccess = await _productGetController.fetchProductData();

    if (!isSuccess) {
      showSnackBar(context, _productGetController.errorMessage ?? 'Something went wrong');
      debugPrint('Something went wrong');
    }
    else {
      showSnackBar(context, 'success');
    }
  }
}
