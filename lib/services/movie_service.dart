 import 'package:critic/constants/globals.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/ui/search_movies/search_movies_result.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

class MovieService extends GetxService {
  /// Search for movies by id.
  Future<MovieModel> getMovieByID({required String id}) async {
    Map<String, String> params = {
      'i': '$id',
      'apiKey': Globals.OMDB_API_KEY,
    };

    Uri uri = Uri.https(Globals.OMDB_API_URL, '', params);

    http.Response response = await http.get(
      uri,
      headers: {'content-type': 'application/json'},
    );

    try {
      Map<String, dynamic> map = json.decode(response.body);
      MovieModel movie = MovieModel.fromJson(map);
      return movie;
    } catch (e) {
      throw PlatformException(message: e.toString(), code: '');
    }
  }

  /// Search for movies by search term.
  Future<SearchMoviesResult> search({required String term}) async {
    final String baseUrl = 'https://${Globals.OMDB_API_URL}';
    final response = await http
        .get(Uri.parse('$baseUrl/?s=$term&apiKey=${Globals.OMDB_API_KEY}'));
    final results = json.decode(response.body);

    if (results['Response'] == 'False') {
      throw Exception(results['Error']);
    } else {
      return SearchMoviesResult.fromJson(results);
    }
  }
}
