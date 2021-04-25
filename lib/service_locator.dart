import 'package:get_it/get_it.dart';

import 'services/auth_service.dart';
import 'services/block_user_service.dart';
import 'services/critique_service.dart';
import 'services/fcm_notification_service.dart';
import 'services/modal_service.dart';
import 'services/movie_service.dart';
import 'services/recommendations_service.dart';
import 'services/storage_service.dart';
import 'services/suggestion_service.dart';
import 'services/user_service.dart';
import 'services/validation_service.dart';

GetIt locator = GetIt.I;

void setUpLocater() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => BlockUserService());
  locator.registerLazySingleton(() => CritiqueService());
  locator.registerLazySingleton(() => FCMNotificationService());
  locator.registerLazySingleton(() => ModalService());
  locator.registerLazySingleton(() => MovieService());
  locator.registerLazySingleton(() => RecommendationsService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => SuggestionService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => ValidationService());
}
