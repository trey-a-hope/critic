import 'dart:async';
import 'dart:convert';

import 'package:critic/blocs/searchMovies/SearchMoviesResult.dart';
import 'package:http/http.dart' as http;

class SearchMoviesClient {
  final String baseUrl;
  final http.Client httpClient;
  final String apiKey;

  SearchMoviesClient(
      {http.Client httpClient,
      this.baseUrl = "http://www.omdbapi.com",
      this.apiKey = '1f1c49fc'})
      : this.httpClient = httpClient ?? http.Client();

  Future<SearchMoviesResult> search(String term) async {
    final response =
        await httpClient.get(Uri.parse("$baseUrl/?s=$term&apiKey=$apiKey"));
    final results = json.decode(response.body);

    if (results['Response'] == 'False') {
      throw Exception(results['Error']);
    } else {
      return SearchMoviesResult.fromJson(results);
    }
  }
}
