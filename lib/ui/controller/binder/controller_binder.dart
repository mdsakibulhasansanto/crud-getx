import 'package:get/get.dart';

import '../product_get_controller.dart';


class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductGetController());
  }
}
