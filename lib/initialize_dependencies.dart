import 'package:critic/services/util_service.dart';
import 'package:get/get.dart';
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

GetIt locator = GetIt.I; // TODO: Delete this.

void initializeDependencies() {
  Get.lazyPut(() => AuthService());
  Get.lazyPut(() => BlockUserService());
  Get.lazyPut(() => CritiqueService());
  Get.lazyPut(() => FCMNotificationService());
  Get.lazyPut(() => ModalService());
  Get.lazyPut(() => MovieService());
  Get.lazyPut(() => RecommendationsService());
  Get.lazyPut(() => StorageService());
  Get.lazyPut(() => SuggestionService());
  Get.lazyPut(() => UserService());
  Get.lazyPut(() => UtilService());
  Get.lazyPut(() => ValidationService());
}
