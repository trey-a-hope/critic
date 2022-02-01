part of 'search_users_bloc.dart';

class SearchUsersRepository {
  final SearchUsersCache cache;

  final Algolia _algolia = Algolia.init(
    applicationId: ALGOLIA_APP_ID,
    apiKey: ALGOLIA_SEARCH_API_KEY,
  );

  SearchUsersRepository({required this.cache});

  Future<List<UserModel>> search(String term) async {
    if (cache.contains(term)) {
      return cache.get(term);
    } else {
      AlgoliaQuery query = _algolia.instance.index('Users').query(term);
      // query = query.setFacetFilter('isGem:$_isSearchingGems');

      final List<AlgoliaObjectSnapshot> results =
          (await query.getObjects()).hits;

      final List<dynamic> uids =
          results.map((result) => result.data['uid']).toList();

      // Convert algolia results to user objects.
      List<UserModel> users = [];
      for (int i = 0; i < uids.length; i++) {
        String uid = uids[i];
        UserModel user = await locator<UserService>().retrieveUser(uid: uid);
        users.add(user);
      }

      cache.set(term, users);
      return users;
    }
  }
}
