import 'package:crud/data/urls/api.dart';
import 'package:crud/data/services/network_caller.dart';
import 'package:get/get.dart';

class ProductUpdateController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> updateProduct(String id, Map<String, dynamic> data) async {
    _inProgress = true;
    _errorMessage = null;
    update();

    final String url = Api().updateProduct(id);

    final response = await NetworkCaller.postRequest(
      url: url,
      body: data,
    );

    if (response.isSuccess && response.responseData?['status'] == 'success') {
      _inProgress = false;
      update();
      return true;
    } else {
      _errorMessage = response.errorMessage ?? 'Update failed';
      _inProgress = false;
      update();
      return false;
    }
  }
}
