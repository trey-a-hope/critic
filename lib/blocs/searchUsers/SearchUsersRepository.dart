import 'dart:async';
import 'package:critic/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import '../../Constants.dart';
import 'SearchUsersCache.dart';

class SearchUsersRepository {
  final SearchUsersCache cache;

  final Algolia _algolia = Algolia.init(
    applicationId: ALGOLIA_APP_ID,
    apiKey: ALGOLIA_SEARCH_API_KEY,
  );

  SearchUsersRepository({@required this.cache});

  Future<List<UserModel>> search(String term) async {
    if (cache.contains(term)) {
      return cache.get(term);
    } else {
      AlgoliaQuery query = _algolia.instance.index('Users').search(term);
      // query = query.setFacetFilter('isGem:$_isSearchingGems');

      final List<AlgoliaObjectSnapshot> results =
          (await query.getObjects()).hits;

      final List<UserModel> users = results
          .map((result) => UserModel.fromAlgolia(result))
          .toList();

      cache.set(term, users);
      return users;
    }
  }
}
