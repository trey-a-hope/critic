import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/NewCommentModel.dart';
import 'package:critic/models/NewCritiqueModel.dart';
import 'package:critic/services/MovieService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

abstract class INewCritiqueService {
  Future<List<NewCritiqueModel>> listByUser({
    @required String uid,
    @required int limit,
    String lastID,
  });

  Future<List<NewCritiqueModel>> listByGenre({
    @required String genre,
    @required int limit,
    String lastID,
  });

  Future<void> create({
    @required NewCritiqueModel critique,
  });

  Future<void> delete({
    @required String id,
  });

  Future<void> update({
    @required String id,
    @required Map<String, dynamic> params,
  });

  Future<void> addComment(
      {@required String id, @required NewCommentModel comment});

  Future<void> addLike({
    @required String id,
    @required String uid,
  });
}

//TODO: CREATE METHOD FOR LISTING CRITIQUES BY GENRE AND BY USER

class NewCritiqueService extends INewCritiqueService {
  @override
  Future<List<NewCritiqueModel>> listByUser({
    @required String uid,
    @required int limit,
    String lastID,
  }) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesListByUser',
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

      List<NewCritiqueModel> critiques = results
          .map(
            (result) => NewCritiqueModel.fromJSON(map: result),
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
  Future<List<NewCritiqueModel>> listByGenre({
    @required String genre,
    @required int limit,
    String lastID,
  }) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesListByGenre',
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

      List<NewCritiqueModel> critiques = results
          .map(
            (result) => NewCritiqueModel.fromJSON(map: result),
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
  Future<void> create({@required NewCritiqueModel critique}) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesCreate',
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
  Future<void> delete({@required String id}) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesDelete',
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
      {@required String id, @required Map<String, dynamic> params}) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesUpdate',
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
      {@required String id, @required NewCommentModel comment}) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesAddComment',
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
    @required String id,
    @required String uid,
  }) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesAddLike',
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
}
