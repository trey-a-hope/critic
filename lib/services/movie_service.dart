import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/blocs/search_movies/search_movies_bloc.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

abstract class IMovieService {
  Future<MovieModel> getMovieByID({required String id});

  Future<SearchMoviesResult> search({required String term});

  Future<List<MovieModel>> getPopularMovies();
}

class MovieService extends IMovieService {
  final String apiKey = '7c304592';
  final String authority = 'www.omdbapi.com';

  final CollectionReference _dataDB =
      FirebaseFirestore.instance.collection('Data');

  @override
  Future<MovieModel> getMovieByID({required String id}) async {
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
      Map<String, dynamic> map = json.decode(response.body);
      MovieModel movie = MovieModel.fromJson(map);
      return movie;
    } catch (e) {
      throw PlatformException(message: e.toString(), code: '');
    }
  }

  @override
  Future<SearchMoviesResult> search({required String term}) async {
    final String baseUrl = 'https://www.omdbapi.com';
    final response =
        await http.get(Uri.parse("$baseUrl/?s=$term&apiKey=$apiKey"));
    final results = json.decode(response.body);

    if (results['Response'] == 'False') {
      throw Exception(results['Error']);
    } else {
      return SearchMoviesResult.fromJson(results);
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    try {
      DocumentSnapshot popularMoviesDocSnap =
          await _dataDB.doc('popularMovies').get();

      List<dynamic> popularMoviesMap =
          popularMoviesDocSnap['imdbIDs'] as List<dynamic>;

      List<String> popularMoviesIMDBIDs = [];

      popularMoviesMap.forEach((imdbID) {
        popularMoviesIMDBIDs.add(imdbID);
      });

      List<MovieModel> movies = [];

      for (int i = 0; i < popularMoviesIMDBIDs.length; i++) {
        MovieModel movie = await getMovieByID(id: popularMoviesIMDBIDs[i]);
        movies.add(movie);
      }
      return movies;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
