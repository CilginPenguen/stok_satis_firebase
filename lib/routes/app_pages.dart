import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/Auth/auth_bindings.dart';
import 'package:stok_satis_firebase/modules/Auth/auth_page.dart';
import 'package:stok_satis_firebase/modules/profile/profile_bindings.dart';
import 'package:stok_satis_firebase/modules/profile/profile_page.dart';
import 'package:stok_satis_firebase/modules/signup_temp/signup_bindings.dart';
import 'package:stok_satis_firebase/modules/signup_temp/signup_page.dart';
import 'package:stok_satis_firebase/modules/login/login_bindings.dart';
import 'package:stok_satis_firebase/modules/login/login_page.dart';

import '../modules/basket/basket_bindings.dart';
import '../modules/basket/basket_page.dart';
import '../modules/home/home_bindings.dart';
import '../modules/home/home_page.dart';
import '../modules/screensaver/screensaver_page.dart';
import '../modules/signup_temp/verify_page.dart';
import '../splash/splash_bindings.dart';
import '../splash/splash_page.dart';

abstract class AppRoutes {
  static const initial = splash;
  static const shop = "/shop";
  static const splash = "/splash";
  static const screenSaver = "/sSaver";
  static const home = "/home";
  static const basket = "/shop";
  static const login = "/login";
  static const signUp = "/signUp";
  static const verify = "/verify";
  static const auth = "/auth";
  static const profile = "/profil";
}

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBindings(),
    ),
    GetPage(name: AppRoutes.screenSaver, page: () => ScreensaverPage()),
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashPage(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: AppRoutes.shop,
      page: () => BasketPage(),
      binding: BasketBindings(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => SignupPage(),
      binding: SignupBindings(),
    ),
    GetPage(
      name: AppRoutes.verify,
      page: () => VerifyPage(),
      binding: SignupBindings(),
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => AuthPage(),
      binding: AuthBindings(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfilePage(),
      binding: ProfileBindings(),
    ),
  ];
}
