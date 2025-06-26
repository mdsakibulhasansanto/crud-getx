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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
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
            return const Center(child: CircularProgressIndicator());
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
                    child: Center(
                      child: Text("No products found."),
                    ),
                  )
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await getProductMethod();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.productList.length,
              itemBuilder: (context, index) {
                final product = controller.productList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                        /// Centered Image
                        Expanded(
                          flex: 0,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: product.img != null && product.img!.isNotEmpty
                                  ? Image.network(
                                product.img!,
                                width: 100,
                                height: 170,
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 100,
                                    height: 170,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.broken_image, color: Colors.grey),
                                  );
                                },
                              )
                                  : Container(
                                width: 100,
                                height: 170,
                                color: Colors.blue.shade50,
                                child: const Icon(Icons.image_not_supported, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// Product Info
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
                              Text("Price : ৳${product.unitPrice ?? '0'}",
                                  style: const TextStyle(color: Colors.green)),
                              Text("Total : ৳${product.totalPrice ?? '0'}",
                                  style: const TextStyle(color: Colors.green)),
                              const SizedBox(height: 4),
                              Text(
                                product.createdDate ?? '',
                                style: const TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                              const SizedBox(height: 8),

                              /// Action Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple.shade50,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)),
                                      ),
                                      onPressed: () {},
                                      child: const Text("View",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple)),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.indigo.shade50,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)),
                                      ),
                                      onPressed: () {},
                                      child: const Text("Update",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo)),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade50,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)),
                                      ),
                                      onPressed: () {},
                                      child: const Text("Delete",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
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
      showSnackBar(context, 'success');
    }
  }
}
