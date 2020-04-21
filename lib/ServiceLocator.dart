import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/services/StorageService.dart';
import 'package:critic/services/UserService.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.I;

void setUpLocater() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => MovieService());
  locator.registerLazySingleton(() => ValidationService());
  locator.registerLazySingleton(() => ModalService());
  locator.registerLazySingleton(() => CritiqueService());
  locator.registerLazySingleton(() => StorageService());

  //Register models?
  // locator.registerFactory<UserModel>(() => UserModel());
}
