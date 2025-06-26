

import 'package:crud/data/services/network_caller.dart';
import 'package:crud/data/urls/api.dart';

import 'package:get/get.dart';

class CreateProductController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> productCreate(Map<String, dynamic> product) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Api().createProduct,
      body: product,
    );

    if (response.isSuccess && response.responseData?['status'] == 'success') {
      isSuccess = true;
      _errorMessage = null;
    } else {
      if (response.statusCode == 401) {
        _errorMessage = 'User name / password incorrect';
      } else {
        _errorMessage = response.errorMessage;
      }
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}
