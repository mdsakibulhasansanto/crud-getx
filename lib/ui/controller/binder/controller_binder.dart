import 'package:crud/ui/controller/create_product_controller.dart';
import 'package:get/get.dart';

import '../product_get_controller.dart';
import '../product_update_controller.dart';


class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductGetController());

    // Get.lazyPut(() => CreateController());
    Get.lazyPut( () => CreateProductController());
    Get.lazyPut( () => ProductUpdateController());
  }
}
