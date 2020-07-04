import 'package:critic/blocs/searchMovies/SearchMoviesResult.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/pages/SearchResultsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

abstract class IMovieService {
  // Future<MovieModel> getMovieByTitle({@required String title});
  Future<MovieModel> getMovieByID({@required String id});
  // Future<MovieSearchResult> search({
  //   @required String term,
  //   @required int page,
  // });
  Future<SearchMoviesResult> search({@required String term});
}

class MovieService extends IMovieService {
  final String apiKey = '7c304592';
  final String authority = 'www.omdbapi.com';

  @override
  Future<MovieModel> getMovieByID({@required String id}) async {
    Map<String, String> params = {
      'i': '$id',
      'apiKey': apiKey,
    };

    Uri uri = Uri.https(authority, '', params);

    http.Response response = await http.get(
      uri,
      headers: {'content-type': 'application/json'},
    );

    try {
      Map bodyMap = json.decode(response.body);
      MovieModel movie = MovieModel.fromJSON(map: bodyMap);
      return movie;
    } catch (e) {
      throw PlatformException(message: e.toString(), code: '');
    }
  }

  @override
  Future<SearchMoviesResult> search({@required String term}) async {
    final String baseUrl = 'http://www.omdbapi.com';
    final response =
        await http.get(Uri.parse("$baseUrl/?s=$term&apiKey=$apiKey"));
    final results = json.decode(response.body);

    if (results['Response'] == 'False') {
      throw Exception(results['Error']);
    } else {
      return SearchMoviesResult.fromJson(results);
    }
  }

  //@override
  // Future<MovieModel> getMovieByTitle({@required String title}) async {
  //   Map<String, String> params = {
  //     't': '$title',
  //     'apiKey': apiKey,
  //   };

  //   Uri uri = Uri.https(authority, '', params);

  //   http.Response response = await http.get(
  //     uri,
  //     headers: {'content-type': 'application/json'},
  //   );

  //   try {
  //     Map bodyMap = json.decode(response.body);
  //     MovieModel movie = MovieModel.fromJSON(map: bodyMap);
  //     return movie;
  //   } catch (e) {
  //     throw PlatformException(message: e.toString(), code: '');
  //   }
  // }

  // Future<MovieSearchResult> search({
  //   @required String term,
  //   @required int page,
  // }) async {
  //   final http.Response response = await http.get(
  //       Uri.https(
  //           authority, '', {'s': '$search', 'apiKey': apiKey, 'page': '$page'}),
  //       headers: {'content-type': 'application/json'});
  //   final results = json.decode(response.body);

  //   if (response.statusCode == 200) {
  //     return MovieSearchResult.fromJson(results);
  //   } else {
  //     throw MovieSearchResultError.fromJson(results);
  //   }
  // }

  // @override
  // Future<List<MovieSearchModel>> getMovieBySearch(
  //     {@required String search, @required int page}) async {
  //   Map<String, String> params = {
  //     's': '$search',
  //     'apiKey': apiKey,
  //     'page': '$page'
  //   };

  //   Uri uri = Uri.https(authority, '', params);

  //   http.Response response = await http.get(
  //     uri,
  //     headers: {'content-type': 'application/json'},
  //   );

  //   try {
  //     Map bodyMap = json.decode(response.body);
  //     if (bodyMap['Response'] == 'False') {
  //       return [];
  //     }

  //     final List<MovieSearchModel> movies = (bodyMap['Search'] as List<dynamic>)
  //         .map((dynamic item) => MovieSearchModel.fromJSON(map: item))
  //         .toList();
  //     return movies;
  //   } catch (e) {
  //     throw PlatformException(message: e.toString(), code: '');
  //   }
  // }
}
