import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tanker_app/src/auth/views/auth_screen.dart';
import 'package:tanker_app/src/main_binding.dart';
import 'package:tanker_app/utils/app_theme.dart';
import 'package:tanker_app/utils/custom_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        title: 'Tanker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: customPrimaryColor,
          errorColor: Colors.red[800],
          // backgroundColor: const Color(0xFFF2F3F8),
          backgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: AppTheme.fontName,
          textTheme: AppTheme.textTheme,
        ),
        initialBinding: MainBinding(),
        initialRoute: AuthScreen.routeName,
        getPages: customRoutes,
      );
}

Map<int, Color> color = {
  50: const Color.fromRGBO(86, 178, 227, .1),
  100: const Color.fromRGBO(86, 178, 227, .2),
  200: const Color.fromRGBO(86, 178, 227, .3),
  300: const Color.fromRGBO(86, 178, 227, .4),
  400: const Color.fromRGBO(86, 178, 227, .5),
  500: const Color.fromRGBO(86, 178, 227, .6),
  600: const Color.fromRGBO(86, 178, 227, .7),
  700: const Color.fromRGBO(86, 178, 227, .8),
  800: const Color.fromRGBO(86, 178, 227, .9),
};

MaterialColor customPrimaryColor = MaterialColor(0xFF56B2E3, color);
