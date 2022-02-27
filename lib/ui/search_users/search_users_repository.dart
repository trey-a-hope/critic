import 'package:algolia/algolia.dart';
import 'package:critic/constants/globals.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/user_service.dart';
import 'package:critic/ui/search_users/search_users_cache.dart';
import 'package:get/get.dart';

class SearchUsersRepository {
  SearchUsersRepository({required this.cache});

  /// Cache for storing user search results.
  final SearchUsersCache cache;

  /// Instantiate user service.
  final UserService _userService = Get.find();

  /// Initialize Algolia package.
  final Algolia _algolia = Algolia.init(
    applicationId: Globals.ALGOLIA_APP_ID,
    apiKey: Globals.ALGOLIA_SEARCH_API_KEY,
  );

  Future<List<UserModel>> search(String term) async {
    if (cache.contains(term)) {
      return cache.get(term);
    } else {
      AlgoliaQuery query = _algolia.instance.index('users').query(term);
      // query = query.setFacetFilter('isGem:$_isSearchingGems');

      final List<AlgoliaObjectSnapshot> results =
          (await query.getObjects()).hits;

      final List<dynamic> uids =
          results.map((result) => result.data['uid']).toList();

      // Convert algolia results to user objects.
      List<UserModel> users = [];
      for (int i = 0; i < uids.length; i++) {
        UserModel user = await _userService.retrieveUser(uid: uids[i]);
        users.add(user);
      }

      cache.set(term, users);
      return users;
    }
  }
}
