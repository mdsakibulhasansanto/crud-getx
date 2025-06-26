
import 'package:get/get.dart';
import '../../data/models/data_get.dart';
import '../../data/services/network_caller.dart';
import '../../data/urls/api.dart';


class ProductGetController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  Product? _productResponse;
  List<Data> get productList => _productResponse?.data ?? [];

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> fetchProductData() async {
    _inProgress = true;
    _errorMessage = null;
    update();

    final response = await NetworkCaller.getRequest(url: Api().productGetUrl);

    bool isSuccess = false;

    if (response.isSuccess && response.responseData?['data'] != null) {
      try {
        _productResponse = Product.fromJson(response.responseData!);
        isSuccess = true;
      } catch (e) {
        _errorMessage = 'Something went wrong';
      }
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}
