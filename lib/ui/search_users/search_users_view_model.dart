import 'dart:async';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/ui/search_users/search_users_repository.dart';
import 'package:critic/ui/search_users/search_users_cache.dart';
import 'package:get/get.dart';

class SearchUsersViewModel extends GetxController {
  /// User results.
  List<UserModel> users = [];

  /// Repository for performing movie search.
  final SearchUsersRepository searchUsersRepository = SearchUsersRepository(
    cache: SearchUsersCache(),
  );

  /// Debouncer for preventing search firing multiple times.
  Timer? _debounce;

  /// Deterimines if loading indicator is present.
  bool isLoading = false;

  /// Error message when searching.
  String? errorMessage;

  /// Return the movie or go to movie.
  bool returnUser = Get.arguments['returnUser'];

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    _debounce?.cancel();
    super.onClose();
  }

  void udpateSearchText({required String text}) async {
    /// Display loading indicator.
    isLoading = true;

    /// Clear error message.
    errorMessage = null;

    update();

    /// Cancel debouncer if it's active.
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    /// Set new debouncer value.
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () async {
        if (text.isEmpty) {
          /// Return empty array of results.
          users = [];

          /// Clear loading indicator.
          isLoading = false;

          update();
        } else {
          try {
            /// Attempt to search for movies.
            users = await searchUsersRepository.search(text);

            /// Clear loading indicator.
            isLoading = false;

            update();
          } catch (e) {
            /// Set error message.
            errorMessage = e.toString();

            /// Clear loading indicator.
            isLoading = false;

            update();
          }
        }
      },
    );
  }
}
