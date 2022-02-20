import 'package:critic/constants/globals.dart';
import 'package:critic/ui/create_critique/create_critique_view.dart';
import 'package:critic/ui/home/home_view.dart';
import 'package:critic/ui/login/login_view.dart';
import 'package:critic/ui/main/main_view.dart';
import 'package:critic/ui/profile/profile_view.dart';
import 'package:critic/ui/recommendations/recommendations_view.dart';
import 'package:critic/ui/search_movies/search_movies_view.dart';
import 'package:critic/ui/settings/settings_view.dart';
import 'package:critic/ui/watch_list/watch_list_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();
  static final routes = [
    GetPage(name: '/', page: () => const MainView()),
    GetPage(
        name: Globals.ROUTES_CREATE_CRITIQUE, page: () => CreateCritiqueView()),
    GetPage(name: Globals.ROUTES_HOME, page: () => HomeView()),
    GetPage(name: Globals.ROUTES_LOGIN, page: () => const LoginPage()),
    GetPage(name: Globals.ROUTES_PROFILE, page: () => ProfileView()),
    GetPage(
        name: Globals.ROUTES_RECOMMENDATIONS,
        page: () => RecommendationsView()),
    GetPage(name: Globals.ROUTES_SEARCH_MOVIES, page: () => SearchMoviesView()),
    GetPage(name: Globals.ROUTES_SETTINGS, page: () => SettingsView()),
    GetPage(name: Globals.ROUTES_WATCH_LIST, page: () => WatchListView()),
  ];
}
