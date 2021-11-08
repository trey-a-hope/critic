import 'package:critic/Constants.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/models/comment_model.dart';
import 'package:critic/models/critique_model.dart';
import 'package:critic/services/movie_service.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

abstract class ICritiqueService {
  Future<CritiqueModel> get({
    required String id,
  });

  Future<int> count({required String uid});

  Future<List<CritiqueModel>> list({
    required int limit,
    String? lastID,
  });

  Future<List<CritiqueModel>> listSimilar({
    String? id,
    required String imdbID,
  });

  Future<List<CritiqueModel>> listByUser({
    required String uid,
    required int limit,
    String? lastID,
  });

  Future<List<CritiqueModel>> listByGenre({
    required String genre,
    required int limit,
    String lastID,
  });

  Future<void> create({
    required CritiqueModel critique,
  });

  Future<void> delete({
    required String id,
  });

  Future<void> deleteAll();

  Future<void> update({
    required String id,
    required Map<String, dynamic> params,
  });

  Future<void> addComment({
    required String id,
    required CommentModel comment,
  });

  Future<void> addLike({
    required String id,
    required String uid,
  });

  Future<void> removeLike({
    required String id,
    required String uid,
  });
}

class CritiqueService extends ICritiqueService {
  @override
  Future<CritiqueModel> get({required String id}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesGet'),
        body: json.encode({
          'id': id,
        }),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      final dynamic result = json.decode(response.body);

      CritiqueModel critique = CritiqueModel.fromJSON(map: result);

      //Attach movie to critique object.
      critique.movie =
          await locator<MovieService>().getMovieByID(id: critique.imdbID);

      return critique;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<CritiqueModel>> listByUser({
    required String uid,
    required int limit,
    String? lastID,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesListByUser'),
        body: json.encode({
          'uid': uid,
          'limit': limit,
          'last_id': lastID,
        }),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      final List<dynamic> results = json.decode(response.body) as List<dynamic>;

      List<CritiqueModel> critiques = results
          .map(
            (result) => CritiqueModel.fromJSON(map: result),
          )
          .toList();

      //Attach movie to critique object.
      for (int i = 0; i < critiques.length; i++) {
        critiques[i].movie =
            await locator<MovieService>().getMovieByID(id: critiques[i].imdbID);
      }

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<CritiqueModel>> listByGenre({
    required String genre,
    required int limit,
    String? lastID,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesListByGenre'),
        body: json.encode({
          'genre': genre,
          'limit': limit,
          'last_id': lastID,
        }),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      final List<dynamic> results = json.decode(response.body) as List<dynamic>;

      List<CritiqueModel> critiques = results
          .map(
            (result) => CritiqueModel.fromJSON(map: result),
          )
          .toList();

      //Attach movie to critique object.
      for (int i = 0; i < critiques.length; i++) {
        critiques[i].movie =
            await locator<MovieService>().getMovieByID(id: critiques[i].imdbID);
      }

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> create({required CritiqueModel critique}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesCreate'),
        body: json.encode(critique.toJson()),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesDelete'),
        body: json.encode({'id': id}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> update(
      {required String id, required Map<String, dynamic> params}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesUpdate'),
        body: json.encode({'id': id, 'params': params}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> addComment(
      {required String id, required CommentModel comment}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesAddComment'),
        body: json.encode({'id': id, 'comment': comment.toJson()}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> addLike({
    required String id,
    required String uid,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesAddLike'),
        body: json.encode({'id': id, 'uid': uid}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<CritiqueModel>> listSimilar({
    String? id,
    required String imdbID,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesListSimilar'),
        body: json.encode({
          'id': id,
          'imdbID': imdbID,
        }),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      final List<dynamic> results = json.decode(response.body) as List<dynamic>;

      List<CritiqueModel> critiques = results
          .map(
            (result) => CritiqueModel.fromJSON(map: result),
          )
          .toList();

      //Attach movie to critique object.
      for (int i = 0; i < critiques.length; i++) {
        critiques[i].movie =
            await locator<MovieService>().getMovieByID(id: critiques[i].imdbID);
      }

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> removeLike({
    required String id,
    required String uid,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesRemoveLike'),
        body: json.encode({'id': id, 'uid': uid}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<int> count({required String uid}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesCount'),
        body: json.encode({'uid': uid}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      // final dynamic result = json.decode(response.body);

      return 0;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesDeleteAll'),
        //body: json.encode({'id': id}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<CritiqueModel>> list({
    required int limit,
    String? lastID,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesList'),
        body: json.encode({
          'limit': limit,
          'last_id': lastID,
        }),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      final List<dynamic> results = json.decode(response.body) as List<dynamic>;

      List<CritiqueModel> critiques = results
          .map(
            (result) => CritiqueModel.fromJSON(map: result),
          )
          .toList();

      //Attach movie to critique object.
      for (int i = 0; i < critiques.length; i++) {
        critiques[i].movie =
            await locator<MovieService>().getMovieByID(id: critiques[i].imdbID);
      }

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
