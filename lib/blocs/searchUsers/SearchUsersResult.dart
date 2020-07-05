// import 'package:critic/models/SearchMoviesResultItem.dart';
// import 'package:critic/models/UserModel.dart';
// import 'package:flutter/material.dart';
// import 'package:algolia/algolia.dart';

// class SearchUsersResult {
//   final List<UserModel> items;

//   const SearchUsersResult({@required this.items});

//   static SearchUsersResult fromAlgolia(
//       List<AlgoliaObjectSnapshot> algoliaObjectSnapshots) {
//     List<UserModel> users = algoliaObjectSnapshots
//         .map((result) => UserModel.extractAlgoliaObjectSnapshot(result))
//         .toList();

//     return SearchUsersResult(items: users);
//   }
// }
