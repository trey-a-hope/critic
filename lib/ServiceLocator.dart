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
  print('Registering services...');
  locator.registerLazySingleton(() => AuthService());
  print('AuthService registered: ${locator.isRegistered<AuthService>()}');
  locator.registerLazySingleton(() => UserService());
  print('UserService registered: ${locator.isRegistered<UserService>()}');
  locator.registerLazySingleton(() => MovieService());
  print('MovieService registered: ${locator.isRegistered<MovieService>()}');
  locator.registerLazySingleton(() => ValidationService());
  print(
      'ValidationService registered: ${locator.isRegistered<ValidationService>()}');
  locator.registerLazySingleton(() => ModalService());
  print('ModalService registered: ${locator.isRegistered<ModalService>()}');
  locator.registerLazySingleton(() => CritiqueService());
  print(
      'CritiqueService registered: ${locator.isRegistered<CritiqueService>()}');
  locator.registerLazySingleton(() => StorageService());
  print('StorageService registered: ${locator.isRegistered<StorageService>()}');

  //Register models?
  // locator.registerFactory<UserModel>(() => UserModel());
}
