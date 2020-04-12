import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/SearchQueryModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

abstract class IMovieService {
  // Future<MovieModel> getMovieByTitle({@required String title});
  Future<MovieModel> getMovieByID({@required String id});
  Future<List<SearchQueryModel>> getMovieBySearch(
      {@required String search, @required int page});
}

class MovieService extends IMovieService {
  final String apiKey = '1f1c49fc';
  final String authority = 'www.omdbapi.com';
  //final String unencodedPath = '/api/v1/';

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

  @override
  Future<List<SearchQueryModel>> getMovieBySearch(
      {@required String search, @required int page}) async {
    Map<String, String> params = {
      's': '$search',
      'apiKey': apiKey,
      'page': '$page'
    };

    Uri uri = Uri.https(authority, '', params);

    http.Response response = await http.get(
      uri,
      headers: {'content-type': 'application/json'},
    );

    try {
      Map bodyMap = json.decode(response.body);
      if (bodyMap['Response'] == 'False') {
        return [];
      }
      List<dynamic> moviesData = bodyMap['Search'];
      List<SearchQueryModel> movies = List<SearchQueryModel>();
      moviesData.forEach((movieData) {
        SearchQueryModel movie = SearchQueryModel.fromJSON(map: movieData);
        movies.add(movie);
      });
      return movies;
    } catch (e) {
      throw PlatformException(message: e.toString(), code: '');
    }
  }
}
