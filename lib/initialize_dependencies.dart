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

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => BlockUserService(), fenix: true);
    Get.lazyPut(() => CritiqueService(), fenix: true);
    Get.lazyPut(() => FCMNotificationService(), fenix: true);
    Get.lazyPut(() => ModalService(), fenix: true);
    Get.lazyPut(() => MovieService(), fenix: true);
    Get.lazyPut(() => RecommendationsService(), fenix: true);
    Get.lazyPut(() => StorageService(), fenix: true);
    Get.lazyPut(() => SuggestionService(), fenix: true);
    Get.lazyPut(() => UserService(), fenix: true);
    Get.lazyPut(() => UtilService(), fenix: true);
    Get.lazyPut(() => ValidationService(), fenix: true);
  }
}
