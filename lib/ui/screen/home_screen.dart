import 'package:crud/data/urls/api.dart';
import 'package:crud/ui/controller/product_get_controller.dart';
import 'package:crud/ui/screen/product_add_screen.dart';
import 'package:crud/ui/screen/product_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../widgets/snackBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String name = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductGetController _productGetController =
      Get.find<ProductGetController>();

  @override
  void initState() {
    super.initState();
    getProductMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "CRUD APPLICATION",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              getProductMethod();
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Reload',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      body: GetBuilder<ProductGetController>(
        builder: (controller) {
          if (controller.inProgress) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          if (controller.productList.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await getProductMethod();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(
                    height: 300,
                    child: Center(child: Text("No products found.")),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: Colors.green,
            onRefresh: () async {
              await getProductMethod();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.productList.length,
              itemBuilder: (context, index) {
                final product = controller.productList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  elevation: 6,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image
                        Expanded(
                          flex: 0,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child:
                                  product.img != null && product.img!.isNotEmpty
                                      ? Image.network(
                                        product.img!,
                                        width: 100,
                                        height: 170,
                                        fit: BoxFit.contain,
                                        alignment: Alignment.center,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            width: 100,
                                            height: 170,
                                            color: Colors.grey.shade300,
                                            child: const Icon(
                                              Icons.broken_image,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      )
                                      : Container(
                                        width: 100,
                                        height: 170,
                                        color: Colors.blue.shade50,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                        ),
                                      ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        //  Product Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName ?? 'No name',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text("Code : ${product.productCode ?? 'N/A'}"),
                              Text("Qty : ${product.qty ?? '0'}"),
                              Text(
                                "Price : ৳${product.unitPrice ?? '0'}",
                                style: const TextStyle(color: Colors.green),
                              ),
                              Text(
                                "Total : ৳${product.totalPrice ?? '0'}",
                                style: const TextStyle(color: Colors.green),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.createdDate ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),

                              /// buttons view ,update , delete
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.deepPurple.shade50,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: const Text(
                                        "View",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.indigo.shade50,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Map<String, dynamic> productPass = {
                                          'id': product.sId,
                                          'name': product.productName,
                                          'price': product.unitPrice,
                                          'totalPrice': product.totalPrice,
                                          'qu': product.qty,
                                          'imageUrl': product.img,
                                          'code': product.productCode,
                                        };

                                        Get.toNamed(
                                          ProductUpdateScreen.name,
                                          arguments: productPass,
                                        );
                                      },
                                      child: const Text(
                                        "Update",
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade50,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        _deleteProduct('${product.sId}');
                                      },
                                      child: const Text(
                                        "Delete",
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 10,

                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(ProductAddScreen.name);
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.grey,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> getProductMethod() async {
    final bool isSuccess = await _productGetController.fetchProductData();

    if (!isSuccess) {
      showSnackBar(
        context,
        _productGetController.errorMessage ?? 'Something went wrong',
      );
      debugPrint('Something went wrong');
    } else {
      showSnackBar(context, 'Success');
    }
  }

  Future<void> _deleteProduct(String id) async {
    final Uri url = Uri.parse(Api().deleteProduct(id));

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product deleted successfully")),
        );
        await getProductMethod();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete product (${response.statusCode})"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error occurred: $e")));
    }
  }
}
