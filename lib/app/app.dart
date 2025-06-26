import 'package:crud/ui/screen/home_screen.dart';
import 'package:crud/ui/screen/product_add_screen.dart';
import 'package:crud/ui/screen/product_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../ui/controller/binder/controller_binder.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // StatusBar Color set
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBinder(),
      initialRoute: HomeScreen.name,
      getPages: [
        GetPage(name: HomeScreen.name, page: () => const HomeScreen()),
        GetPage(name: ProductAddScreen.name, page: () => const ProductAddScreen()),
        GetPage(name: ProductUpdateScreen.name, page: () => const ProductUpdateScreen()),
      ],
    );
  }
}
