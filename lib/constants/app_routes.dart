import 'package:critic/ui/home/home_view.dart';
import 'package:critic/ui/login/login_view.dart';
import 'package:critic/ui/main/main_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(name: '/', page: () => const MainPage()),
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/home', page: () => const HomePage()),
  ];
}
