import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/FCMNotificationService.dart';
import 'package:critic/services/FollowerService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/services/StorageService.dart';
import 'package:critic/services/UserService.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.I;

void setUpLocater() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => CritiqueService());
  locator.registerLazySingleton(() => FCMNotificationService());
  locator.registerLazySingleton(() => FollowerService());
  locator.registerLazySingleton(() => ModalService());
  locator.registerLazySingleton(() => MovieService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => ValidationService());
}
